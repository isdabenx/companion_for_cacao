import 'package:companion_for_cacao/shared/widgets/async_loading_widget.dart';
import 'package:companion_for_cacao/shared/widgets/async_error_widget.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/start_button_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_expansion_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_player_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The whole game setup on one scrollable page: players, expansions and
/// modules are always visible — there is no forced order between them, so
/// no stepper hiding the sections you are not on.
class GameSetupWidget extends ConsumerWidget {
  const GameSetupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSetupAsync = ref.watch(gameSetupProvider);
    final isStarted = ref.watch(
      gameSetupProvider.select((s) => s.value?.isStarted ?? false),
    );

    return gameSetupAsync.when(
      data: (_) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: IgnorePointer(
              ignoring: isStarted,
              child: Opacity(
                opacity: isStarted ? 0.6 : 1.0,
                child: LayoutBuilder(
                  builder: (context, constraints) =>
                      constraints.maxWidth >= _sideBySideFrom
                      ? const _TwoPaneSetup()
                      : const _StackedSetup(),
                ),
              ),
            ),
          ),
          const StartButtonWidget(),
        ],
      ),
      loading: () => const AsyncLoadingWidget(),
      error: (error, _) => AsyncErrorWidget(error: error),
    );
  }

  /// Narrower than this and two columns would squeeze both.
  static const double _sideBySideFrom = AppBreakpoints.mediumMin;
}

/// One column, everything in order. What a phone held upright gets.
class _StackedSetup extends StatelessWidget {
  const _StackedSetup();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      children: [
        const _PlayersSectionHeader(),
        AppSpacing.verticalS,
        const StepPlayerWidget(),
        AppSpacing.verticalL,
        _SectionHeader(
          title: AppLocalizations.of(context).expansionsModulesSection,
        ),
        AppSpacing.verticalS,
        const StepExpansionWidget(),
      ],
    );
  }
}

/// Players beside expansions, each scrolling on its own.
///
/// Stacked in a short window these two sections shared one cramped viewport:
/// a phone in landscape showed two of the four colours, clipped, with
/// everything else below the fold. They are independent choices with no order
/// between them, so side by side costs nothing and shows both at once.
class _TwoPaneSetup extends StatelessWidget {
  const _TwoPaneSetup();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: const [
                _PlayersSectionHeader(),
                AppSpacing.verticalS,
                StepPlayerWidget(),
              ],
            ),
          ),
          AppSpacing.horizontalL,
          Expanded(
            child: ListView(
              children: [
                _SectionHeader(
                  title: AppLocalizations.of(context).expansionsModulesSection,
                ),
                AppSpacing.verticalS,
                const StepExpansionWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final List<Widget>? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.sectionTitlePlain),
        if (trailing != null) ...[AppSpacing.horizontalS, ...trailing!],
      ],
    );
  }
}

/// The players header keeps its live count badge and the "need more
/// players" nudge next to the title.
class _PlayersSectionHeader extends ConsumerWidget {
  const _PlayersSectionHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = ref.watch(
      gameSetupProvider.select((s) => s.value?.players.length ?? 0),
    );

    return _SectionHeader(
      title: AppLocalizations.of(context).playersSection,
      trailing: [
        Container(
          constraints: const BoxConstraints(minWidth: 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.greenDarker.withValues(alpha: 0.1),
            borderRadius: AppShapes.radius(AppShapes.radiusM),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people, size: 14, color: AppColors.greenDarker),
              const SizedBox(width: AppSpacing.xs),
              Text('$selectedCount/4', style: AppTextStyles.badgeCount),
            ],
          ),
        ),
        if (selectedCount < 2) ...[
          const SizedBox(width: 6),
          Container(
            constraints: const BoxConstraints(minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.3),
              borderRadius: AppShapes.radius(AppShapes.radiusS),
            ),
            child: Text(
              AppLocalizations.of(context).needMorePlayers(2 - selectedCount),
              textAlign: TextAlign.center,
              style: AppTextStyles.warningText,
            ),
          ),
        ],
      ],
    );
  }
}
