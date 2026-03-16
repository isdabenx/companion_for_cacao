import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RuleScreen extends StatelessWidget {
  const RuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Rules',
      body: ContainerFullStyleWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                unawaited(
                  context.push(
                    AppRoutes.rulePdf,
                    extra: const <String, String>{
                      'title': 'Instructions',
                      'pdfPath': Assets.ruleCacaoPdf,
                    },
                  ),
                );
              },
              child: Card(
                color: AppColors.greenNormal,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(Assets.boardgameCacao),
                        radius: 30,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Instructions',
                        style: AppTextStyles.titleTextStyle.copyWith(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                unawaited(
                  context.push(
                    AppRoutes.rulePdf,
                    extra: const <String, String>{
                      'title': 'Overview',
                      'pdfPath': Assets.ruleCacaoOverviewPdf,
                    },
                  ),
                );
              },
              child: Card(
                color: AppColors.greenNormal,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(Assets.boardgameCacao),
                        radius: 30,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Overview',
                        style: AppTextStyles.titleTextStyle.copyWith(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
