import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/action_card_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

/// Home launchpad: a brand hero over the main destinations as large action
/// cards, with the app description and feature list tucked into an "About"
/// section so the first screen reads as a way in, not a wall of text.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _repoUrl =
      'https://github.com/isdabenx/companion_for_cacao';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final actions = <ActionCardWidget>[
      ActionCardWidget(
        title: l10n.menuGameSetup,
        icon: Icons.group,
        onTap: () => context.go(AppRoutes.gameSetup),
      ),
      ActionCardWidget(
        title: l10n.menuTiles,
        icon: Icons.widgets,
        onTap: () => context.go(AppRoutes.tiles),
      ),
      ActionCardWidget(
        title: l10n.menuScores,
        icon: Icons.calculate,
        onTap: () => context.go(AppRoutes.scoreCalculator),
      ),
      ActionCardWidget(
        title: l10n.menuRules,
        icon: Icons.library_books,
        onTap: () => context.go(AppRoutes.rules),
      ),
    ];

    return UpgradeAlert(
      child: CustomScaffoldWidget(
        title: l10n.menuHome,
        // Option C: no cream panel — the cards sit directly on the leafy
        // backdrop, so white cards get maximum contrast and the green frames
        // the launchpad.
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.m,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.verticalS,
              // Brand hero.
              Text(
                'Companion for',
                style: AppTextStyles.titleTextStyle.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              Image.asset(Assets.cacaoTile, height: 132),
              AppSpacing.verticalS,
              Text(
                l10n.homeTagline,
                style: AppTextStyles.instruction,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalXl,
              // Main destinations.
              for (var i = 0; i < actions.length; i++) ...[
                actions[i]
                    .animate()
                    .fadeIn(duration: 280.ms, delay: (70 * i).ms)
                    .slideY(
                      begin: 0.08,
                      end: 0,
                      duration: 280.ms,
                      delay: (70 * i).ms,
                      curve: Curves.easeOutCubic,
                    ),
                if (i < actions.length - 1) AppSpacing.verticalM,
              ],
              AppSpacing.verticalXl,
              _AboutSection(l10n: l10n, repoUrl: _repoUrl),
              AppSpacing.verticalM,
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.l10n, required this.repoUrl});

  final AppLocalizations l10n;
  final String repoUrl;

  @override
  Widget build(BuildContext context) {
    final completed = l10n.homeCompletedFeatures.split('\n');
    final pending = l10n.homePendingFeatures.split('\n');

    return Theme(
      // Drop the default ExpansionTile dividers so it blends into the panel.
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      // ExpansionTile paints its ListTile ink on the nearest Material; the
      // decorated panel behind it would otherwise trip a framework assert.
      child: Material(
        type: MaterialType.transparency,
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: AppSpacing.s),
          title: Text(l10n.homeAboutTitle, style: AppTextStyles.markdownH2),
          iconColor: AppColors.brown,
          collapsedIconColor: AppColors.brown,
          children: [
            Align(alignment: Alignment.centerLeft, child: Text(l10n.homeIntro)),
            AppSpacing.verticalL,
            HeaderWidget(text: l10n.homeCompletedFeaturesTitle),
            for (final feature in completed)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Text(feature),
              ),
            AppSpacing.verticalL,
            HeaderWidget(text: l10n.homePendingFeaturesTitle),
            for (final feature in pending)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Text(feature),
              ),
            AppSpacing.verticalL,
            HeaderWidget(text: l10n.homeContactTitle),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.homeContactBody),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: GestureDetector(
                onTap: () => unawaited(launchUrl(Uri.parse(repoUrl))),
                child: Text(
                  repoUrl,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary,
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
