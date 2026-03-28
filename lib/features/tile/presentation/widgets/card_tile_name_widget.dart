import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardTileNameWidget extends StatelessWidget {
  const CardTileNameWidget({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 130;
        return Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            name,
            style: isCompact
                ? AppTextStyles.tileNameSmall
                : AppTextStyles.tileName,
          ),
        );
      },
    );
  }
}
