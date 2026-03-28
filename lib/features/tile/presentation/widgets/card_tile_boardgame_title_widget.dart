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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 130;
        return Column(
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    title.toUpperCase(),
                    style: isCompact
                        ? AppTextStyles.boardgameTitle.copyWith(fontSize: 11.5)
                        : AppTextStyles.boardgameTitle,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: color, thickness: 0.75),
          ],
        );
      },
    );
  }
}
