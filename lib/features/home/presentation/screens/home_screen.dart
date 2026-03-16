import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completedFeatures = <String>[
      '🏠 Main Menu: Quick access to all functionalities.',
      '🗂 Tile Database: Access a complete database of tiles.',
      '🎲 Game Setup: Select players, expansions, and modules.',
    ];

    final inProgressFeatures = <String>[
      '📖 Integrated Manuals: Access manuals for the base game and expansions.',
      '📊 In-Game Assistance: Quick reference for rules and tile details.',
    ];

    final pendingFeatures = <String>[
      '🕒 Turn Timer: Control the duration of each turn.',
      '🏆 Final Score Calculation: Automatic score calculator.',
      '⚙️ Customizable Settings: Personalize the game experience.',
      '🌐 Multilingual Support: Interface available in multiple languages.',
      '🚀 Future Updates: Support for new expansions and more.',
      '🔍 Tile Filtering: Filter tiles based on various criteria.',
    ];

    return CustomScaffoldWidget(
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
              const SizedBox(height: 8),
              Center(child: Image.asset(Assets.cacaoTile)),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Companion for Cacao is a mobile application developed with Flutter designed to assist players of the Cacao board game and its expansions. '
                  'The goal is to provide digital tools that enhance the gaming experience by facilitating score tracking, rule consultation, and game management.',
                ),
              ),
              const SizedBox(height: 20),
              const HeaderWidget(text: 'Completed Features'),
              for (final String feature in completedFeatures)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(feature),
                ),
              const SizedBox(height: 20),
              const HeaderWidget(text: 'In-Progress Features'),
              for (final String feature in inProgressFeatures)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(feature),
                ),
              const SizedBox(height: 20),
              const HeaderWidget(text: 'Pending Features'),
              for (final String feature in pendingFeatures)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(feature),
                ),
              const SizedBox(height: 20),
              const HeaderWidget(text: 'Contact Me'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'For suggestions, improvements, errors, or any other inquiries, '
                  'you can visit our GitHub repository. The application is open source '
                  'and we are always looking for collaborators to help improve it.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Visit our GitHub repository:',
                  style: AppTextStyles.markdownBody.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
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
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'On GitHub, you can open issues to report bugs, suggest new features, '
                  'or even submit pull requests with your own contributions. '
                  'We strive to constantly improve the application and appreciate any help!',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
