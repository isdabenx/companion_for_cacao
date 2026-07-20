import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/select_module_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepModuleWidget extends ConsumerWidget {
  const StepModuleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Expansions that bring modules, so each group can say where its
    // modules come from.
    final expansionsWithModules = ref.watch(
      gameSetupProvider.select(
        (s) =>
            s.value?.expansions.where((e) => e.modules.isNotEmpty).toList() ??
            [],
      ),
    );

    final isBigGame = ref.watch(
      gameSetupProvider.select((s) => s.value?.isBigGame ?? false),
    );

    // Single source of truth for the Big Game rule (entity getter)
    final showBigGameToggle = ref.watch(
      gameSetupProvider.select((s) => s.value?.canEnableBigGame ?? false),
    );

    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.selectModulesHint),
        if (expansionsWithModules.isEmpty)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.l),
                  child: Text(
                    l10n.noExpansionWithModules,
                    style: AppTextStyles.boardgameTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        for (final expansion in expansionsWithModules) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.m,
              bottom: AppSpacing.xs,
            ),
            child: Text(
              expansion.localizedName(l10n),
              style: AppTextStyles.sectionSublabel,
            ),
          ),
          for (final ModuleEntity module in expansion.modules)
            SelectModuleWidget(module: module),
        ],
        if (showBigGameToggle)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.m),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppLocalizations.of(context).bigGame,
                style: AppTextStyles.bodyMedium,
              ),
              subtitle: Text(
                AppLocalizations.of(context).bigGameHint,
                style: AppTextStyles.sectionSublabel,
              ),
              trailing: Switch(
                value: isBigGame,
                activeTrackColor: AppColors.greenDark,
                inactiveTrackColor: AppColors.greenLight,
                onChanged: (value) =>
                    ref.read(gameSetupProvider.notifier).setBigGame(value),
              ),
              onTap: () =>
                  ref.read(gameSetupProvider.notifier).setBigGame(!isBigGame),
            ),
          ),
      ],
    );
  }
}
