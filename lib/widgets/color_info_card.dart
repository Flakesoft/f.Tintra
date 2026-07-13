import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();

    return 'RGB($r, $g, $b)';
  }


  Future<void> _copyText(
    BuildContext context,
    String text,
    String label,
  ) async {

    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );


    if (!context.mounted) return;


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('$label copied'),

        duration:
            const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    final scheme =
        Theme.of(context).colorScheme;


    return Column(
      children: [

        Container(
          width: 96,
          height: 96,

          decoration: BoxDecoration(

            color: color,

            borderRadius:
                BorderRadius.circular(20),

            border: Border.all(
              color:
                  scheme.outlineVariant,
              width: 1,
            ),
          ),
        ),


        const SizedBox(height: 16),


        InkWell(

          borderRadius:
              BorderRadius.circular(8),

          onTap:
              () => _copyText(
                context,
                hex,
                'HEX',
              ),

          child: Padding(

            padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),

            child: Text(

              hex,

              style:
                  Theme.of(context)
                      .textTheme
                      .titleLarge,
            ),
          ),
        ),


        const SizedBox(height: 4),


        InkWell(

          borderRadius:
              BorderRadius.circular(8),

          onTap:
              () => _copyText(
                context,
                rgb,
                'RGB',
              ),

          child: Padding(

            padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),

            child: Text(

              rgb,

              style:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium,
            ),
          ),
        ),


        const SizedBox(height: 12),


        Text(

          'Tap the value to copy',

          style:
              Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color:
                        scheme
                            .onSurfaceVariant,
                  ),
        ),
      ],
    );
  }
}