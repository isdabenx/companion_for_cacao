import 'package:collection/collection.dart';
import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/core/utils/string_extensions.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/utils/preparation_render_units.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/hut_layout_selector_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_preparation_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_celebration_overlay.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_group_card.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/worker_selector_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/player_display_l10n.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/utils/preparation_phase_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Guided mode: one render unit per page, for preparing the table with
/// the hands busy — the same units, order and completion logic as the
/// checklist ([DetailedPreparationWidget]), one thing at a time.
class GuidedPreparationWidget extends ConsumerStatefulWidget {
  const GuidedPreparationWidget({required this.preparation, super.key});

  final List<PreparationEntity> preparation;

  @override
  ConsumerState<GuidedPreparationWidget> createState() =>
      _GuidedPreparationWidgetState();
}

class _GuidedPreparationWidgetState
    extends ConsumerState<GuidedPreparationWidget> {
  PageController? _controller;
  int _currentPage = 0;
  List<bool>? _lastCompletion;
  bool _celebrationDismissed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(settingsRepositoryProvider).markPreparationSeen();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Completing the unit you are looking at auto-advances after a short
  /// pause — never on pipeline regenerations (those rebuild the whole
  /// completion list, detected by a length change).
  void _maybeAutoAdvance(List<bool> completion) {
    final previous = _lastCompletion;
    _lastCompletion = completion;
    if (previous == null || previous.length != completion.length) return;
    final page = _currentPage;
    if (page >= completion.length - 1) return;
    if (!completion[page] || previous[page]) return;
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final controller = _controller;
      if (controller == null || !controller.hasClients) return;
      if (controller.page?.round() != page) return;
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Widget _unitContent(
    PreparationRenderUnit unit, {
    required bool hutThrowRegistered,
    required String Function(String?) playerTitle,
  }) {
    switch (unit) {
      case GroupUnit(:final groupId, :final steps):
        if (groupId == PreparationGroups.jungle) {
          return PreparationGroupCard(
            key: ValueKey(groupId),
            groupId: groupId,
            title: AppLocalizations.of(context).jungleGroupTitle,
            steps: steps,
            // The step details are the point of a guided page.
            initiallyExpandedRows: true,
          );
        }
        if (groupId == PreparationGroups.returnToBox) {
          return ReturnToBoxCard(
            key: ValueKey(groupId),
            groupId: groupId,
            title: AppLocalizations.of(context).returnToBoxTitle,
            subtitle: AppLocalizations.of(context).returnToBoxSubtitle,
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
          // The step details are the point of a guided page.
          initiallyExpandedRows: true,
        );
      case StepUnit(:final step):
        if (step.id == NewWorkersModuleHandler.selectionStepId) {
          return const WorkerSelectorWidget();
        }
        if (step.id == NewWorkersModuleHandler.buildStepId) {
          return PreparationCard(
            key: ValueKey(step.id),
            preparation: step,
            initiallyExpanded: true,
            footer: const WorkerBuildSummary(),
          );
        }
        final isHutThrow = step.id == HutsModuleHandler.marketStepId;
        return PreparationCard(
          key: ValueKey(step.id),
          preparation: step,
          initiallyExpanded: true,
          footer: isHutThrow ? const HutThrowRegisterRow() : null,
          onCheckTapOverride: isHutThrow
              ? () => showHutLayoutEditor(context, ref)
              : null,
          isCompletedOverride: isHutThrow ? hutThrowRegistered : null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final units = buildRenderUnits(widget.preparation);

    final storedCompletionMap = ref.watch(
      gameSetupProvider.select(
        (s) => Map<String, bool>.fromEntries(
          s.value?.preparation.map((p) => MapEntry(p.id, p.isCompleted)) ?? [],
        ),
      ),
    );
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

    final completion = [
      for (final unit in units)
        unit.steps.every((s) => completionMap[s.id] ?? s.isCompleted),
    ];

    // Opening guided mode jumps to the first incomplete unit.
    if (_controller == null) {
      final firstIncomplete = completion.indexWhere((done) => !done);
      _currentPage = firstIncomplete == -1 ? 0 : firstIncomplete;
      _controller = PageController(initialPage: _currentPage);
    }

    // Pipeline regenerations can shrink the unit list: clamp, never crash.
    if (units.isNotEmpty && _currentPage >= units.length) {
      _currentPage = units.length - 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && (_controller?.hasClients ?? false)) {
          _controller!.jumpToPage(_currentPage);
        }
      });
    }

    _maybeAutoAdvance(completion);

    final allComplete = completion.isNotEmpty && completion.every((c) => c);
    if (!allComplete && _celebrationDismissed) {
      _celebrationDismissed = false;
    }

    String playerTitle(String? colorName) {
      if (colorName == null) return '';
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
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: units.length,
                      onPageChanged: (page) =>
                          setState(() => _currentPage = page),
                      itemBuilder: (context, index) {
                        final unit = units[index];
                        final phase = unit.steps.first.phase;
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.m,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xl,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        phase.localizedName(l10n),
                                        style: AppTextStyles.sectionSublabel,
                                      ),
                                    ),
                                    Text(
                                      '${index + 1} / ${units.length}',
                                      style: AppTextStyles.phaseCounter,
                                    ),
                                  ],
                                ),
                              ),
                              AppSpacing.verticalS,
                              _unitContent(
                                unit,
                                hutThrowRegistered: hutThrowRegistered,
                                playerTitle: playerTitle,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.l,
                      AppSpacing.s,
                      AppSpacing.l,
                      AppSpacing.m,
                    ),
                    child: Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _currentPage > 0
                              ? () => _controller?.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                )
                              : null,
                          icon: const Icon(Icons.chevron_left, size: 20),
                          label: Text(l10n.guidedBack),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: _currentPage < units.length - 1
                              ? () => _controller?.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                )
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.greenDark,
                          ),
                          icon: const Icon(Icons.chevron_right, size: 20),
                          label: Text(l10n.guidedNext),
                        ),
                      ],
                    ),
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
