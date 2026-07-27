import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single module as a selectable chip. Lives inside its expansion's card
/// (see `ExpansionCardWidget`); long-press reveals what the module adds.
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
    final l10n = AppLocalizations.of(context);

    return Tooltip(
      message: module.localizedDescription(l10n),
      triggerMode: TooltipTriggerMode.longPress,
      child: SelectableChip(
        isSelected: isSelected,
        onTap: () => ref.read(gameSetupProvider.notifier).toggleModule(module),
        selectedColor: AppColors.greenDarker,
        unselectedColor: AppColors.greenNormal,
        selectedBorderColor: AppColors.greenDarker,
        unselectedBorderColor: AppColors.greenNormal,
        borderRadius: AppShapes.radiusM,
        showShadow: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.brown,
            ),
            AppSpacing.horizontalS,
            Text(
              module.localizedName(l10n),
              style: AppTextStyles.tileName.copyWith(
                color: isSelected ? AppColors.white : AppColors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
