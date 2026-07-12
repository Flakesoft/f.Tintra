import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageState {
  final String path;
  final img.Image image;
  final Color? selectedColor;

  const ImageState({
    required this.path,
    required this.image,
    this.selectedColor,
  });

  ImageState copyWith({
    String? path,
    img.Image? image,
    Color? selectedColor,
  }) {
    return ImageState(
      path: path ?? this.path,
      image: image ?? this.image,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
