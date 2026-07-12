import 'package:flutter/material.dart';

class ColorInfoCard extends StatelessWidget {
  final Color color;

  const ColorInfoCard({
    super.key,
    required this.color,
  });

  String get hex {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  String get rgb {
    return 'RGB(${color.red}, ${color.green}, ${color.blue})';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          hex,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 4),

        Text(
          rgb,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
