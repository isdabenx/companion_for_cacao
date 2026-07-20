import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completedFeatures = <String>[
      '🏠 Main Menu: Quick access to all functionalities.',
      '🗂 Tile Database: Comprehensive catalog of tiles.',
      '🔍 Tile Filtering: Search and filter by multiple criteria.',
      '🌴 Cacao Base Game: Full support and game setup.',
      '🍫 Chocolatl Expansion: Full support including all 4 modules.',
      '🚀 Diamante Expansion: Full support including all 4 modules.',
      '🎲 Game Dashboard: Summary, preparation, and tiles in play.',
      '🌟 Big Game Variant: Integration of all modules and expansions.',
      '📖 Integrated Manuals: Read the game rules.',
      '🏆 Score Calculator: Automatic final scoring with official tie rules.',
      '📊 Adaptive UI: Optimized design for different screen sizes.',
      '🔄 Auto-Updater: Automatic detection of new versions.',
    ];

    final pendingFeatures = <String>[
      '🕒 Turn Timer: Control the duration of each turn.',
      '📜 Game History: Record of finished games and player stats.',
      '⚙️ Custom Settings: Adjust the game experience.',
      '🌐 Multi-language Support: Interface in multiple languages.',
    ];

    return UpgradeAlert(
      child: CustomScaffoldWidget(
        title: 'Home',
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    'Companion for Cacao is a mobile application developed with Flutter designed to assist players of the Cacao board game and its expansions. '
                    'The goal is to provide digital tools that enhance the gaming experience by facilitating score tracking, rule consultation, and game management.',
                  ),
                ),
                AppSpacing.verticalXl,
                const HeaderWidget(text: 'Completed Features'),
                for (final String feature in completedFeatures)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(feature),
                  ),
                AppSpacing.verticalXl,
                const HeaderWidget(text: 'Pending Features'),
                for (final String feature in pendingFeatures)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(feature),
                  ),
                AppSpacing.verticalXl,
                const HeaderWidget(text: 'Contact Me'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    'For suggestions, improvements, bug reports, or any other inquiries, '
                    'you can visit our GitHub repository. The application is open-source '
                    'and we are always looking for contributors to help improve it.',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    'Visit our GitHub repository:',

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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    'On GitHub, you can open "issues" to report bugs, suggest new features, '
                    'or even submit "pull requests" with your own contributions. '
                    'We strive to constantly improve the app and appreciate any help!',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
