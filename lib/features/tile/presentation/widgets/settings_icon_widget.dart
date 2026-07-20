import 'dart:async';

import 'package:companion_for_cacao/config/constants/tile_settings.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_item_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class SettingsIconWidget extends StatelessWidget {
  const SettingsIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context).displaySettingsTooltip,
      icon: const Icon(Icons.settings),
      onPressed: () {
        unawaited(
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: true,
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.l,
                    right: AppSpacing.l,
                    bottom: AppSpacing.xxl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s,
                        ),
                        child: Text(
                          l10n.settingsSheetTitle.toUpperCase(),
                          style: AppTextStyles.boardgameTitlePlain.copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      AppSpacing.verticalL,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s,
                        ),
                        child: Text(
                          l10n.settingsGeneralSection.toUpperCase(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: AppColors.brown.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      SettingsItemWidget(
                        title: l10n.settingBoardgameTitle,
                        settingsName: TileSettings.boardgameInTitle,
                      ),
                      SettingsItemWidget(
                        title: l10n.settingShowQuantity,
                        settingsName: TileSettings.showQuantity,
                      ),
                      SettingsItemWidget(
                        title: l10n.settingCompactLayout,
                        settingsName: TileSettings.compactTileLayout,
                      ),
                      const Divider(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s,
                        ),
                        child: Text(
                          l10n.settingsBadgesSection.toUpperCase(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: AppColors.brown.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      SettingsItemWidget(
                        title: l10n.settingBadgeTypeInText,
                        settingsName: TileSettings.badgeTypeInText,
                      ),
                      SettingsItemWidget(
                        title: l10n.settingBadgeTypeInImage,
                        settingsName: TileSettings.badgeTypeInImage,
                      ),
                      const Divider(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s,
                        ),
                        child: Text(
                          l10n.settingsPlayerColorsSection.toUpperCase(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: AppColors.brown.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      SettingsItemWidget(
                        title: l10n.settingPlayerColorInBorder,
                        settingsName: TileSettings.playerColorInBorder,
                      ),
                      SettingsItemWidget(
                        title: l10n.settingPlayerColorInCircle,
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
