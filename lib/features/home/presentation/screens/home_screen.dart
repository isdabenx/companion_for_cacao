import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Feature lists live in the ARB as one string per list, one bullet
    // per line, so translators keep them together.
    final completedFeatures = l10n.homeCompletedFeatures.split('\n');
    final pendingFeatures = l10n.homePendingFeatures.split('\n');

    return UpgradeAlert(
      child: CustomScaffoldWidget(
        title: l10n.menuHome,
        body: ContainerFullStyleWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Companion for',
                    style: AppTextStyles.titleTextStyle.copyWith(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalS,
                Center(child: Image.asset(Assets.cacaoTile)),
                AppSpacing.verticalXl,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(l10n.homeIntro),
                ),
                AppSpacing.verticalXl,
                HeaderWidget(text: l10n.homeCompletedFeaturesTitle),
                for (final String feature in completedFeatures)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(feature),
                  ),
                AppSpacing.verticalXl,
                HeaderWidget(text: l10n.homePendingFeaturesTitle),
                for (final String feature in pendingFeatures)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(feature),
                  ),
                AppSpacing.verticalXl,
                HeaderWidget(text: l10n.homeContactTitle),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(l10n.homeContactBody),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    l10n.homeVisitRepo,
                    style: AppTextStyles.markdownBody.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: GestureDetector(
                    onTap: () {
                      final url = Uri.parse(
                        'https://github.com/isdabenx/companion_for_cacao',
                      );
                      unawaited(launchUrl(url));
                    },
                    child: Text(
                      'https://github.com/isdabenx/companion_for_cacao',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(l10n.homeGithubBody),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
