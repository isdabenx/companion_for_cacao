import 'package:companion_for_cacao/features/game_setup/presentation/widgets/game_setup_widget.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';

class GameSetupScreen extends StatelessWidget {
  const GameSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffoldWidget(
      body: ContainerFullStyleWidget(child: GameSetupWidget()),
      title: 'Game Setup',
    );
  }
}
