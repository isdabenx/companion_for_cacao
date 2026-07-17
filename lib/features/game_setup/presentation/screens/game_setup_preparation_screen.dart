import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_preparation_widget.dart';
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

    return CustomScaffoldWidget(
      title: 'Preparation',
      showBackButton: true,
      body: DetailedPreparationWidget(preparation: liveSetup.preparation),
    );
  }
}
