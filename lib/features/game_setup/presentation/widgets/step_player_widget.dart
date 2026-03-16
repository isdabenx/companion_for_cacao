import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/player_row_widget.dart';
import 'package:flutter/material.dart';

class StepPlayerWidget extends StatelessWidget {
  const StepPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select colors for each player and enter the name. Minimum 2 players',
        ),
        for (final String color in AppColors.colors.keys)
          PlayerRowWidget(colorString: color),
      ],
    );
  }
}
