import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../models/image_state.dart';
import '../services/image_picker_service.dart';
import '../widgets/color_info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ImageState? imageState;
  bool isLoading = false;

  Future<void> _selectImage() async {
    final imageFile = await ImagePickerService.pickImage();

    if (imageFile == null) return;

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    final bytes = await imageFile.readAsBytes();

    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    final resizedImage = img.copyResize(
      decodedImage,
      width: 800,
    );

    if (!mounted) return;

    setState(() {
      imageState = ImageState(
        path: imageFile.path,
        image: resizedImage,
      );

      isLoading = false;
    });
  }

  void _onImageTap(TapDownDetails details) {
    if (imageState == null) return;

    final imageSize =
        MediaQuery.of(context).size.width > 600
            ? 500.0
            : MediaQuery.of(context).size.width * 0.8;

    final scaleX = imageState!.image.width / imageSize;
    final scaleY = imageState!.image.height / imageSize;

    final x = (details.localPosition.dx * scaleX).toInt();
    final y = (details.localPosition.dy * scaleY).toInt();

    if (x < 0 ||
        y < 0 ||
        x >= imageState!.image.width ||
        y >= imageState!.image.height) {
      return;
    }

    final pixel = imageState!.image.getPixel(x, y);

    final color = Color.fromARGB(
      pixel.a.toInt(),
      pixel.r.toInt(),
      pixel.g.toInt(),
      pixel.b.toInt(),
    );

    setState(() {
      imageState = imageState!.copyWith(
        selectedColor: color,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final imageSize = screenWidth > 600
        ? 500.0
        : screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('f.Tintra'),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 250),

                  child: isLoading

                      ? Column(
                          key: const ValueKey('loading'),

                          children: [

                            Icon(
                              Icons.hourglass_top,
                              size: 72,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),

                            const SizedBox(height: 20),

                            Text(
                              'Loading image...',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ],
                        )

                      : imageState != null

                          ? GestureDetector(
                              key:
                                  const ValueKey('image'),

                              onTapDown:
                                  _onImageTap,

                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20),

                                child: Image.file(
                                  File(imageState!.path),

                                  height:
                                      imageSize,

                                  width:
                                      imageSize,

                                  fit:
                                      BoxFit.contain,
                                ),
                              ),
                            )

                          : Icon(
                              Icons.colorize,

                              key:
                                  const ValueKey('empty'),

                              size: 96,

                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,
                            ),
                ),


                const SizedBox(height: 24),


                if (imageState?.selectedColor != null)

                  ColorInfoCard(
                    color:
                        imageState!.selectedColor!,
                  )

                else if (imageState != null)

                  Text(
                    'Tap the image to pick a color',

                    style:
                        Theme.of(context)
                            .textTheme
                            .bodyMedium,
                  ),


                const SizedBox(height: 32),


                FilledButton.icon(

                  onPressed:
                      isLoading
                          ? null
                          : _selectImage,

                  icon:
                      const Icon(Icons.image),

                  label:
                      Text(
                        imageState == null
                            ? 'Select image'
                            : 'Choose another image',
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}