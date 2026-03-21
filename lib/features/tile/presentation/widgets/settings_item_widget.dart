import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsItemWidget extends ConsumerWidget {
  const SettingsItemWidget({
    required this.title,
    required this.settingsName,
    super.key,
  });

  final String title;
  final String settingsName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileSettingsAsync = ref.watch(tileSettingsProvider);

    return tileSettingsAsync.when(
      data: (tileSettings) => ListTile(
        title: Text(title, style: AppTextStyles.bodyMedium),
        trailing: Switch(
          value: tileSettings.settings(settingsName),
          activeTrackColor: AppColors.greenDark,
          inactiveTrackColor: AppColors.greenLight,
          onChanged: (_) => ref
              .read(tileSettingsProvider.notifier)
              .toggleSettings(settingsName),
        ),
        onTap: () => ref
            .read(tileSettingsProvider.notifier)
            .toggleSettings(settingsName),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
