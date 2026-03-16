import 'dart:async';

import 'package:companion_for_cacao/config/constants/tile_settings.dart';
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
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsItemWidget(
                    title: 'Boardgame title',
                    settingsName: TileSettings.boardgameInTitle,
                  ),
                  SettingsItemWidget(
                    title: 'Badge tile type in text',
                    settingsName: TileSettings.badgeTypeInText,
                  ),
                  SettingsItemWidget(
                    title: 'Badge tile type in image',
                    settingsName: TileSettings.badgeTypeInImage,
                  ),
                  SettingsItemWidget(
                    title: 'Player color in border',
                    settingsName: TileSettings.playerColorInBorder,
                  ),
                  SettingsItemWidget(
                    title: 'Player color in circle',
                    settingsName: TileSettings.playerColorInCircle,
                  ),
                  SettingsItemWidget(
                    title: 'Show quantity',
                    settingsName: TileSettings.showQuantity,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
