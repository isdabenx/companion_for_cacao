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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Base Game'),
              _buildRuleCard(
                context,
                title: 'Instructions',
                pdfPath: Assets.ruleCacaoPdf,
                imagePath: Assets.boardgameCacao,
              ),
              const SizedBox(height: 12),
              _buildRuleCard(
                context,
                title: 'Overview',
                pdfPath: Assets.ruleCacaoOverviewPdf,
                imagePath: Assets.boardgameCacao,
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Expansion: Chocolatl'),
              _buildRuleCard(
                context,
                title: 'Chocolatl Rules',
                pdfPath: Assets.ruleCacaoChocolatlPdf,
                imagePath: Assets.boardgameChocolatl,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.titleTextStyle.copyWith(
          fontSize: 18,
          color: AppColors.brown,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildRuleCard(
    BuildContext context, {
    required String title,
    required String pdfPath,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        unawaited(
          context.push(
            AppRoutes.rulePdf,
            extra: <String, String>{'title': title, 'pdfPath': pdfPath},
          ),
        );
      },
      child: Card(
        color: AppColors.greenNormal,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(imagePath), radius: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleTextStyle.copyWith(fontSize: 22),
                ),
              ),
              const Icon(Icons.picture_as_pdf, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
