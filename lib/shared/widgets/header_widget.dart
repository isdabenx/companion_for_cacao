import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.greenNormal,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(text, style: AppTextStyles.markdownH2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
