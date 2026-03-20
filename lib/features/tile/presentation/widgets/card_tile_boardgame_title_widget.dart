import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardTileBoardgameTitleWidget extends StatelessWidget {
  const CardTileBoardgameTitleWidget({
    required this.title,
    required this.color,
    super.key,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(title.toUpperCase(), style: AppTextStyles.boardgameTitle),
        ),
        Divider(height: 1, color: color, thickness: 0.75),
      ],
    );
  }
}
