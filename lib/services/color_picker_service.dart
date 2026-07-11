import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ColorPickerService {
  static Future<Color?> getPixelColor({
    required String imagePath,
    required int x,
    required int y,
  }) async {
    try {
      final bytes = await File(imagePath).readAsBytes();

      final image = img.decodeImage(bytes);

      if (image == null) {
        return null;
      }

      if (x < 0 || y < 0 || x >= image.width || y >= image.height) {
        return null;
      }

      final pixel = image.getPixel(x, y);

      return Color.fromARGB(
        pixel.a.toInt(),
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );
    } catch (e) {
      debugPrint('Failed to read pixel color: $e');
      return null;
    }
  }
}
