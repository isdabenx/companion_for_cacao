import 'dart:async';

import 'package:companion_for_cacao/config/constants/tile_settings.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_item_widget.dart';
import 'package:flutter/material.dart';

class SettingsIconWidget extends StatelessWidget {
  const SettingsIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        unawaited(
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'SETTINGS',
                          style: AppTextStyles.boardgameTitlePlain.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'GENERAL',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: AppColors.brown.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      const SettingsItemWidget(
                        title: 'Boardgame title',
                        settingsName: TileSettings.boardgameInTitle,
                      ),
                      const SettingsItemWidget(
                        title: 'Show quantity',
                        settingsName: TileSettings.showQuantity,
                      ),
                      const Divider(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'BADGES',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: AppColors.brown.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      const SettingsItemWidget(
                        title: 'Badge tile type in text',
                        settingsName: TileSettings.badgeTypeInText,
                      ),
                      const SettingsItemWidget(
                        title: 'Badge tile type in image',
                        settingsName: TileSettings.badgeTypeInImage,
                      ),
                      const Divider(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'PLAYER COLORS',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: AppColors.brown.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      const SettingsItemWidget(
                        title: 'Player color in border',
                        settingsName: TileSettings.playerColorInBorder,
                      ),
                      const SettingsItemWidget(
                        title: 'Player color in circle',
                        settingsName: TileSettings.playerColorInCircle,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
