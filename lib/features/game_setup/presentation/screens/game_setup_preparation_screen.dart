import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_preparation_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';

class GameSetupPreparationScreen extends StatelessWidget {
  const GameSetupPreparationScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Preparation',
      showBackButton: true,
      body: DetailedPreparationWidget(preparation: gameSetup.preparation),
    );
  }
}
