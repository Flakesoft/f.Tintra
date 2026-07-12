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

  Future<void> _selectImage() async {
    final imageFile = await ImagePickerService.pickImage();

    if (imageFile == null) return;

    final bytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) return;

    final resizedImage = img.copyResize(
      decodedImage,
      width: 1000,
    );

    setState(() {
      imageState = ImageState(
        path: imageFile.path,
        image: resizedImage,
      );
    });
  }

  void _onImageTap(TapDownDetails details) {
    if (imageState == null) return;

    const displayedSize = 250.0;

    final scaleX = imageState!.image.width / displayedSize;
    final scaleY = imageState!.image.height / displayedSize;

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

    debugPrint(
      'Color: #${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('f.Tintra'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageState != null)
                GestureDetector(
                  onTapDown: _onImageTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imageState!.path),
                      height: 250,
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.colorize,
                  size: 96,
                  color: Theme.of(context).colorScheme.primary,
                ),

              const SizedBox(height: 24),

              if (imageState?.selectedColor != null)
                ColorInfoCard(
                  color: imageState!.selectedColor!,
                ),

              const SizedBox(height: 24),

              Text(
                imageState?.selectedColor != null
                    ? 'Color selected'
                    : imageState != null
                        ? 'Tap anywhere on the image'
                        : 'Pick a color from an image',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: _selectImage,
                icon: const Icon(Icons.image),
                label: const Text('Select image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}