import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectModuleWidget extends ConsumerWidget {
  const SelectModuleWidget({required this.module, super.key});

  final ModuleEntity module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      gameSetupProvider.select(
        (s) => s.value?.modules.any((e) => e.id == module.id) ?? false,
      ),
    );
    void onToggleModule() {
      ref.read(gameSetupProvider.notifier).toggleModule(module);
    }

    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Flexible(
          // Long-press (or hover) reveals what the module adds to the game.
          child: Tooltip(
            message: module.localizedDescription(l10n),
            triggerMode: TooltipTriggerMode.longPress,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.brown,
                backgroundColor: isSelected
                    ? AppColors.greenDark
                    : AppColors.greenNormal,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onToggleModule,
              child: Text(module.localizedName(l10n)),
            ),
          ),
        ),
      ],
    );
  }
}
