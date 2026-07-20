import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_preparation_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupPreparationScreen extends ConsumerWidget {
  const GameSetupPreparationScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Prefer the live state: applying a worker selection during preparation
    // re-runs the pipeline, and the route extra is only a snapshot taken
    // when the game was started.
    final liveSetup = ref.watch(gameSetupProvider).value ?? gameSetup;
    final (completed, total) = ref.watch(preparationProgressProvider);
    final progress = total == 0 ? 0.0 : completed / total;

    return CustomScaffoldWidget(
      title: AppLocalizations.of(context).titlePreparation,
      showBackButton: true,
      body: Column(
        children: [
          // Global progress: the thin bar under the title answers "how
          // far along is the table?" at a glance.
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: AppColors.brown.withValues(alpha: 0.15),
              color: AppColors.greenDark,
            ),
          ),
          Expanded(
            child: DetailedPreparationWidget(
              preparation: liveSetup.preparation,
            ),
          ),
        ],
      ),
    );
  }
}
