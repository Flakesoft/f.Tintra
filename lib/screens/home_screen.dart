import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../services/color_picker_service.dart';
import '../services/image_picker_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedImagePath;
  Color? selectedColor;

  Future<void> _selectImage() async {
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
        selectedColor = null;
      });
    }
  }

  Future<void> _onImageTap(TapDownDetails details) async {
    if (selectedImagePath == null) return;

    final bytes = await File(selectedImagePath!).readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) return;

    const displayedSize = 250.0;

    final scaleX = image.width / displayedSize;
    final scaleY = image.height / displayedSize;

    final x = (details.localPosition.dx * scaleX).toInt();
    final y = (details.localPosition.dy * scaleY).toInt();

    final color = await ColorPickerService.getPixelColor(
      imagePath: selectedImagePath!,
      x: x,
      y: y,
    );

    if (color != null) {
      setState(() {
        selectedColor = color;
      });

      debugPrint(
        'Color: #${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      );
    }
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
              if (selectedImagePath != null)
                GestureDetector(
                  onTapDown: _onImageTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(selectedImagePath!),
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

              if (selectedColor != null)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

              const SizedBox(height: 24),

              Text(
                selectedColor != null
                    ? 'Color selected'
                    : selectedImagePath != null
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