import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ProcessedImage {
  final img.Image image;
  final Uint8List previewBytes;

  const ProcessedImage({
    required this.image,
    required this.previewBytes,
  });
}

class ImageProcessingService {
  static Future<ProcessedImage?> processImage(String path) async {
    return Isolate.run(() {
      final bytes = File(path).readAsBytesSync();

      final decoded = img.decodeImage(bytes);

      if (decoded == null) return null;

      final resized = img.copyResize(
        decoded,
        width: 800,
      );

      final previewBytes = Uint8List.fromList(
        img.encodePng(resized),
      );

      return ProcessedImage(
        image: resized,
        previewBytes: previewBytes,
      );
    });
  }
}