import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart' as img;

class ImageProcessingService {
  static Future<img.Image?> processImage(String path) async {
    return Isolate.run(() {
      final bytes = File(path).readAsBytesSync();

      final decoded = img.decodeImage(bytes);

      if (decoded == null) return null;

      return img.copyResize(
        decoded,
        width: 800,
      );
    });
  }
}
