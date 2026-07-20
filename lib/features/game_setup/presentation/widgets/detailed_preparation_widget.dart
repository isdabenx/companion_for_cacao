import 'package:collection/collection.dart';
import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/core/utils/string_extensions.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/hut_layout_selector_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_celebration_overlay.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_group_card.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_step_row.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/worker_selector_widget.dart';
import 'package:companion_for_cacao/shared/utils/player_display_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detailed_preparation_widget.g.dart';

// Local provider for phase expansion state
@riverpod
class PhaseExpansion extends _$PhaseExpansion {
  @override
  Map<PreparationPhase, bool> build() {
    return {};
  }

  void toggle(PreparationPhase phase, {required bool isDefaultExpanded}) {
    final currentlyExpanded = state[phase] ?? isDefaultExpanded;
    final newValue = !currentlyExpanded;
    if (newValue == isDefaultExpanded) {
      // Toggling back to default — remove override to keep map clean
      state = Map.from(state)..remove(phase);
    } else {
      state = {...state, phase: newValue};
    }
  }

  void clearAll() {
    state = {};
  }
}

/// True the first time the preparation screen is shown on this device:
/// step rows start expanded so new players read the full instructions
/// without any interaction. [DetailedPreparationWidget] marks it seen.
@riverpod
Future<bool> preparationFirstRun(Ref ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return !(await repository.hasSeenPreparation());
}

/// Overall preparation progress as (completed, total), counting the
/// derived completion of the interactive steps (worker selection, hut
/// throw). Feeds the global progress bar and the celebration overlay.
@riverpod
(int, int) preparationProgress(Ref ref) {
  final preparation = ref.watch(
    gameSetupProvider.select((s) => s.value?.preparation ?? const []),
  );
  final workerSelectionApplied = ref.watch(
    gameSetupProvider.select((s) => s.value?.workerSelection != null),
  );
  final hutThrowRegistered = ref.watch(
    gameSetupProvider.select((s) => s.value?.hutLayout != null),
  );
  var completed = 0;
  for (final step in preparation) {
    final isDone = switch (step.id) {
      NewWorkersModuleHandler.selectionStepId => workerSelectionApplied,
      HutsModuleHandler.marketStepId => hutThrowRegistered,
      _ => step.isCompleted,
    };
    if (isDone) completed++;
  }
  return (completed, preparation.length);
}

/// How one list entry renders: a group card or a standalone step.
sealed class _RenderUnit {
  const _RenderUnit();
}

class _GroupUnit extends _RenderUnit {
  const _GroupUnit(this.groupId, this.steps);
  final String groupId;
  final List<PreparationEntity> steps;
}

class _StepUnit extends _RenderUnit {
  const _StepUnit(this.step);
  final PreparationEntity step;
}

class DetailedPreparationWidget extends ConsumerStatefulWidget {
  const DetailedPreparationWidget({required this.preparation, super.key});

  final List<PreparationEntity> preparation;

  @override
  ConsumerState<DetailedPreparationWidget> createState() =>
      _DetailedPreparationWidgetState();
}

class _DetailedPreparationWidgetState
    extends ConsumerState<DetailedPreparationWidget> {
  final ScrollController _scrollController = ScrollController();
  PreparationPhase? _lastFirstIncompletePhase;
  bool _phaseTracked = false;

  /// The user closed the celebration to keep reviewing; resets as soon
  /// as the preparation is no longer fully complete.
  bool _celebrationDismissed = false;

  @override
  void initState() {
    super.initState();
    // Fire-and-forget: after the first frame the device has seen the
    // preparation screen, so the next visit starts rows collapsed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(settingsRepositoryProvider).markPreparationSeen();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// When completing the last step of a phase auto-advances the flow to the
  /// next one, the collapsed content leaves the list scrolled somewhere in
  /// the middle. Scroll back to the top so the phase headers and the newly
  /// opened section are in view.
  ///
  /// Only FORWARD advances scroll: unchecking a step reopens an earlier
  /// phase right where the user is looking, and manual expand/collapse
  /// never scrolls either.
  void _scrollToTopOnPhaseAdvance(PreparationPhase? current) {
    final previous = _lastFirstIncompletePhase;
    _lastFirstIncompletePhase = current;
    if (!_phaseTracked) {
      _phaseTracked = true;
      return;
    }
    if (current == previous) return;
    // null means every phase is complete — that also counts as advancing.
    final advanced =
        previous != null && (current == null || current.index > previous.index);
    if (!advanced) return;
    // A whole phase just closed: stronger feedback than a single step.
    HapticFeedback.mediumImpact();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // The flow moved on: drop manual expand/collapse overrides (e.g. a
      // section reopened by hand to uncheck something) so the completed
      // section folds and only the new active one stays open.
      ref.read(phaseExpansionProvider.notifier).clearAll();
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  String _getPhaseName(AppLocalizations l10n, PreparationPhase phase) {
    switch (phase) {
      case PreparationPhase.tilePool:
        return l10n.phaseTilePool;
      case PreparationPhase.playerSetup:
        return l10n.phasePlayerSetup;
      case PreparationPhase.boardSetup:
        return l10n.phaseBoardSetup;
      case PreparationPhase.supplies:
        return l10n.phaseSupplies;
    }
  }

  /// Collapses grouped steps into group cards, keeping every other step
  /// standalone. A group renders at the position of its first member.
  List<_RenderUnit> _buildUnits(List<PreparationEntity> items) {
    final units = <_RenderUnit>[];
    final seenGroups = <String>{};
    for (final item in items) {
      final groupId = item.groupId;
      if (groupId == null) {
        units.add(_StepUnit(item));
        continue;
      }
      if (seenGroups.add(groupId)) {
        units.add(
          _GroupUnit(
            groupId,
            items.where((s) => s.groupId == groupId).toList(),
          ),
        );
      }
    }
    return units;
  }

  @override
  Widget build(BuildContext context) {
    final storedCompletionMap = ref.watch(
      gameSetupProvider.select(
        (s) => Map<String, bool>.fromEntries(
          s.value?.preparation.map((p) => MapEntry(p.id, p.isCompleted)) ?? [],
        ),
      ),
    );
    // Interactive steps have no manual checkbox: their completion is
    // derived from the choice they capture, so it stays truthful even when
    // the preparation list is regenerated by the pipeline.
    final workerSelectionApplied = ref.watch(
      gameSetupProvider.select((s) => s.value?.workerSelection != null),
    );
    final hutThrowRegistered = ref.watch(
      gameSetupProvider.select((s) => s.value?.hutLayout != null),
    );
    final completionMap = {
      ...storedCompletionMap,
      NewWorkersModuleHandler.selectionStepId: workerSelectionApplied,
      HutsModuleHandler.marketStepId: hutThrowRegistered,
    };
    final players = ref.watch(
      gameSetupProvider.select((s) => s.value?.players ?? const []),
    );
    final isFirstRun = ref.watch(preparationFirstRunProvider).value ?? false;
    final expansionMap = ref.watch(phaseExpansionProvider);
    final groupedPreparation = groupBy(widget.preparation, (p) => p.phase);

    PreparationPhase? firstIncompletePhase;
    for (final entry in groupedPreparation.entries) {
      final completedCount = entry.value
          .where((p) => completionMap[p.id] ?? p.isCompleted)
          .length;
      if (entry.value.isNotEmpty && completedCount < entry.value.length) {
        firstIncompletePhase = entry.key;
        break;
      }
    }
    _scrollToTopOnPhaseAdvance(firstIncompletePhase);

    final allComplete =
        widget.preparation.isNotEmpty && firstIncompletePhase == null;
    if (!allComplete && _celebrationDismissed) {
      _celebrationDismissed = false;
    }

    String playerTitle(String? colorName) {
      if (colorName == null) return '';
      final l10n = AppLocalizations.of(context);
      final player = players.firstWhereOrNull((p) => p.color == colorName);
      return player?.localizedDisplayName(l10n) ??
          localizedColorName(l10n, colorName).capitalized;
    }

    return Stack(
      children: [
        ContainerFullStyleWidget(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  const SliverPadding(
                    padding: EdgeInsets.only(top: AppSpacing.l),
                  ),
                  for (final entry in groupedPreparation.entries)
                    SliverMainAxisGroup(
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _PhaseHeaderDelegate(
                            phase: entry.key,
                            phaseName: _getPhaseName(
                              AppLocalizations.of(context),
                              entry.key,
                            ),
                            items: entry.value,
                            completionMap: completionMap,
                            isExpanded:
                                expansionMap[entry.key] ??
                                (entry.key == firstIncompletePhase),
                            onTap: () {
                              ref
                                  .read(phaseExpansionProvider.notifier)
                                  .toggle(
                                    entry.key,
                                    isDefaultExpanded:
                                        entry.key == firstIncompletePhase,
                                  );
                            },
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final isDefaultExpanded =
                                entry.key == firstIncompletePhase;
                            final isExpanded =
                                expansionMap[entry.key] ?? isDefaultExpanded;

                            if (!isExpanded) {
                              return const SliverToBoxAdapter(
                                child: SizedBox.shrink(),
                              );
                            }

                            final units = _buildUnits(entry.value);

                            return SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final unit = units[index];
                                switch (unit) {
                                  case _GroupUnit(:final groupId, :final steps):
                                    if (groupId ==
                                        PreparationGroups.returnToBox) {
                                      return ReturnToBoxCard(
                                        key: ValueKey(groupId),
                                        groupId: groupId,
                                        title: AppLocalizations.of(
                                          context,
                                        ).returnToBoxTitle,
                                        subtitle: AppLocalizations.of(
                                          context,
                                        ).returnToBoxSubtitle,
                                        steps: steps,
                                      );
                                    }
                                    final colorName = steps.first.color;
                                    return PreparationGroupCard(
                                      key: ValueKey(groupId),
                                      groupId: groupId,
                                      title: playerTitle(colorName),
                                      colorName: colorName,
                                      steps: steps,
                                      initiallyExpandedRows: isFirstRun,
                                    );
                                  case _StepUnit(:final step):
                                    // Interactive worker selection step
                                    if (step.id ==
                                        NewWorkersModuleHandler
                                            .selectionStepId) {
                                      return const WorkerSelectorWidget();
                                    }
                                    // The hut-throw card completes by registering
                                    // the throw result, not by a manual checkbox.
                                    final isHutThrow =
                                        step.id ==
                                        HutsModuleHandler.marketStepId;
                                    return PreparationCard(
                                      key: ValueKey(step.id),
                                      preparation: step,
                                      initiallyExpanded: isFirstRun,
                                      footer: isHutThrow
                                          ? const HutThrowRegisterRow()
                                          : null,
                                      onCheckTapOverride: isHutThrow
                                          ? () => showHutLayoutEditor(
                                              context,
                                              ref,
                                            )
                                          : null,
                                      isCompletedOverride: isHutThrow
                                          ? hutThrowRegistered
                                          : null,
                                    );
                                }
                              }, childCount: units.length),
                            );
                          },
                        ),
                      ],
                    ),
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: AppSpacing.l),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (allComplete && !_celebrationDismissed)
          PreparationCelebrationOverlay(
            onClose: () => setState(() => _celebrationDismissed = true),
          ),
      ],
    );
  }
}

class _PhaseHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PhaseHeaderDelegate({
    required this.phase,
    required this.phaseName,
    required this.items,
    required this.completionMap,
    required this.isExpanded,
    required this.onTap,
  });

  final PreparationPhase phase;
  final String phaseName;
  final List<PreparationEntity> items;
  final Map<String, bool> completionMap;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Interactive steps count too: the map carries their derived completion
    final phaseCompletedCount = items
        .where((p) => completionMap[p.id] ?? p.isCompleted)
        .length;
    final phaseTotalCount = items.length;
    final isPhaseCompleted =
        phaseTotalCount > 0 && phaseCompletedCount == phaseTotalCount;
    final phaseProgress = phaseTotalCount == 0
        ? 0.0
        : phaseCompletedCount / phaseTotalCount;

    return Material(
      color: AppColors.greenLight,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.s,
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  phaseName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isPhaseCompleted)
                const Icon(Icons.check_circle, color: AppColors.brown, size: 24)
              else ...[
                Text(
                  '$phaseCompletedCount/$phaseTotalCount',
                  style: AppTextStyles.phaseCounter,
                ),
                AppSpacing.horizontalM,
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: phaseProgress,
                    backgroundColor: AppColors.brown.withValues(alpha: 0.15),
                    color: AppColors.brown,
                    strokeWidth: 3,
                  ),
                ),
              ],
              AppSpacing.horizontalM,
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.brown,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant _PhaseHeaderDelegate oldDelegate) {
    return phaseName != oldDelegate.phaseName ||
        items != oldDelegate.items ||
        completionMap != oldDelegate.completionMap ||
        isExpanded != oldDelegate.isExpanded;
  }
}

/// A standalone preparation step: a card hosting one expandable row.
/// Grouped steps render inside [PreparationGroupCard]/[ReturnToBoxCard]
/// instead.
class PreparationCard extends ConsumerWidget {
  const PreparationCard({
    required this.preparation,
    this.footer,
    this.onCheckTapOverride,
    this.isCompletedOverride,
    this.initiallyExpanded = false,
    super.key,
  });

  final PreparationEntity preparation;

  /// Optional extra content under the row (e.g. the hut-throw
  /// registration row). Handles its own taps.
  final Widget? footer;

  /// Replaces the check behavior for steps whose completion is not a
  /// manual checkbox (e.g. the hut throw, completed by registering).
  final VoidCallback? onCheckTapOverride;

  /// Overrides the stored completion flag with a derived one, so it
  /// survives preparation regeneration.
  final bool? isCompletedOverride;

  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: AppColors.cream,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.brown.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PreparationStepRow(
              step: preparation,
              initiallyExpanded: initiallyExpanded,
              isCompletedOverride: isCompletedOverride,
              onCheckTap: onCheckTapOverride,
            ),
            if (footer != null) ...[AppSpacing.verticalS, footer!],
          ],
        ),
      ),
    );
  }
}
