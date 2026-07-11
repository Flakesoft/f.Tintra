import 'package:flutter/material.dart';
import '../services/image_picker_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _selectImage() async {
    final image = await ImagePickerService.pickImage();

    if (image != null) {
      debugPrint('Selected image: ${image.path}');
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
              Icon(
                Icons.colorize,
                size: 96,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Pick a color from an image',
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
