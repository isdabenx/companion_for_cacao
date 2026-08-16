import 'package:companion_for_cacao/config/navigation/app_destinations.dart';
import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/action_card_widget.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RuleScreen extends StatelessWidget {
  const RuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CustomScaffoldWidget(
      destination: AppDestinationId.rules,
      title: l10n.menuRules,
      body: ContainerFullStyleWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(l10n.rulesBaseGame),
              _buildRuleCard(
                context,
                title: l10n.rulesInstructions,
                pdfPath: Assets.ruleCacaoPdf,
                imagePath: Assets.boardgameCacao,
              ),
              AppSpacing.verticalM,
              _buildRuleCard(
                context,
                title: l10n.rulesOverview,
                pdfPath: Assets.ruleCacaoOverviewPdf,
                imagePath: Assets.boardgameCacao,
              ),
              AppSpacing.verticalXl,
              _buildSectionHeader(
                l10n.rulesExpansionHeader(l10n.expansionNameChocolatl),
              ),
              _buildRuleCard(
                context,
                title: l10n.rulesExpansionRules(l10n.expansionNameChocolatl),
                pdfPath: Assets.ruleCacaoChocolatlPdf,
                imagePath: Assets.boardgameChocolatl,
              ),
              AppSpacing.verticalXl,
              _buildSectionHeader(
                l10n.rulesExpansionHeader(l10n.expansionNameDiamante),
              ),
              _buildRuleCard(
                context,
                title: l10n.rulesExpansionRules(l10n.expansionNameDiamante),
                pdfPath: Assets.ruleCacaoDiamantePdf,
                imagePath: Assets.boardgameDiamante,
              ),
              AppSpacing.verticalL,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.m,
        horizontal: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.sectionTitle.copyWith(
          fontSize: 15,
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
    // Shared card component: same surface as everywhere else, with a cover
    // thumbnail as the leading badge and a PDF glyph as the trailing.
    return ActionCardWidget(
      title: title,
      leading: CircleAvatar(backgroundImage: AssetImage(imagePath), radius: 24),
      trailing: const Icon(Icons.picture_as_pdf, color: AppColors.greenDarker),
      onTap: () {
        unawaited(
          context.push(
            AppRoutes.rulePdf,
            extra: <String, String>{'title': title, 'pdfPath': pdfPath},
          ),
        );
      },
    );
  }
}
