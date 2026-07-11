import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_picker_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedImagePath;

  Future<void> _selectImage() async {
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
  }

  void _onImageTap(TapDownDetails details) {
    final position = details.localPosition;

    debugPrint(
      'Tapped at: (${position.dx.toStringAsFixed(1)}, ${position.dy.toStringAsFixed(1)})',
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
              if (selectedImagePath != null)
                GestureDetector(
                  onTapDown: _onImageTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(selectedImagePath!),
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
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
              Text(
                selectedImagePath != null
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