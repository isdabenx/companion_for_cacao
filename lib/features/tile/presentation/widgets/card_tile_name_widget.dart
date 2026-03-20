import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardTileNameWidget extends StatelessWidget {
  const CardTileNameWidget({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(name, style: AppTextStyles.tileName),
    );
  }
}
