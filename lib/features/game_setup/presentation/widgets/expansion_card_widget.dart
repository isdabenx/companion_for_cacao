import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/select_module_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One expansion as an accordion card. Collapsed it shows a cover thumbnail,
/// its name and a hint; selecting it opens the card to reveal the full cover
/// art and its modules as chips — so choosing an expansion and picking its
/// modules happen in one place and the modules can't be missed.
class ExpansionCardWidget extends ConsumerWidget {
  const ExpansionCardWidget({required this.expansion, super.key});

  final BoardgameEntity expansion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isSelected = ref.watch(
      gameSetupProvider.select(
        (s) => s.value?.expansions.any((e) => e.id == expansion.id) ?? false,
      ),
    );
    final selectedModules = ref.watch(
      gameSetupProvider.select(
        (s) =>
            s.value?.modules
                .where((m) => expansion.modules.any((em) => em.id == m.id))
                .length ??
            0,
      ),
    );

    // Selected but no module picked yet: the expansion contributes nothing,
    // so we flag it in amber right on the card (and the start button blocks).
    final needsModules =
        isSelected && expansion.modules.isNotEmpty && selectedModules == 0;

    final coverPath = '${Assets.imagesBoardgamePath}${expansion.filenameImage}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Card(
        color: AppColors.surfaceCard,
        elevation: isSelected ? 4 : 2,
        shape: AppShapes.shape(
          AppShapes.radiusL,
          side: BorderSide(
            color: needsModules
                ? AppColors.warning
                : isSelected
                ? AppColors.greenDarker
                : AppColors.brown.withValues(alpha: 0.10),
            width: isSelected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => ref
                  .read(gameSetupProvider.notifier)
                  .toggleExpansion(expansion),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    // Collapses when the card opens (the big cover takes over
                    // below), sliding the title and counter to the left.
                    AnimatedSize(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      child: isSelected
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.m,
                              ),
                              child: _CoverThumb(path: coverPath),
                            ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expansion.localizedName(l10n),
                            style: AppTextStyles.boardgameTitlePlain,
                          ),
                          const SizedBox(height: 2),
                          if (needsModules)
                            Row(
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 16,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Flexible(
                                  child: Text(
                                    l10n.moduleWarningPickOne,
                                    style: AppTextStyles.sectionSublabel
                                        .copyWith(
                                          color: AppColors.warning,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              isSelected
                                  ? l10n.moduleCountLabel(
                                      selectedModules,
                                      expansion.modules.length,
                                    )
                                  : l10n.expansionTapHint,
                              style: AppTextStyles.sectionSublabel.copyWith(
                                color: isSelected
                                    ? AppColors.greenDarker
                                    : null,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    _SelectControl(isSelected: isSelected),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: isSelected
                  ? _ExpansionBody(
                      coverPath: coverPath,
                      modules: expansion.modules,
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpansionBody extends StatelessWidget {
  const _ExpansionBody({required this.coverPath, required this.modules});

  final String coverPath;
  final List<ModuleEntity> modules;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        0,
        AppSpacing.m,
        AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The full cover art at its real aspect ratio (portrait box),
          // centered — shown whole, never cropped, right where you configure
          // this expansion.
          Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppShapes.radius(AppShapes.radiusM),
                    boxShadow: AppShapes.softSm,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    coverPath,
                    height: 210,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (context, error, stack) => Container(
                      height: 210,
                      width: 152,
                      color: AppColors.greenLight,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.greenDarker,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 240.ms)
              .scaleXY(
                begin: 0.82,
                end: 1,
                alignment: Alignment.topLeft,
                duration: 280.ms,
                curve: Curves.easeOutCubic,
              ),
          AppSpacing.verticalM,
          Text(
            l10n.modulesPickLabel.toUpperCase(),
            style: AppTextStyles.sectionSublabel.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          AppSpacing.verticalS,
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final module in modules) SelectModuleWidget(module: module),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverThumb extends StatelessWidget {
  const _CoverThumb({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppShapes.radius(AppShapes.radiusS),
      child: Image.asset(
        path,
        width: 46,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          width: 46,
          height: 60,
          color: AppColors.greenLight,
          child: const Icon(
            Icons.extension_outlined,
            color: AppColors.greenDarker,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _SelectControl extends StatelessWidget {
  const _SelectControl({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.greenDarker : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.greenDarker : AppColors.greenNormal,
          width: 2,
        ),
      ),
      child: Icon(
        isSelected ? Icons.check : Icons.add,
        size: 18,
        color: isSelected ? AppColors.white : AppColors.greenDarker,
      ),
    );
  }
}
