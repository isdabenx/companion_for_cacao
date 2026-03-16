import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/start_button_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_expansion_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_module_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_player_widget.dart';
import 'package:flutter/material.dart';

class GameSetupWidget extends StatefulWidget {
  const GameSetupWidget({super.key});

  @override
  State<GameSetupWidget> createState() => _GameSetupWidgetState();
}

// List<Step> steps = ;

class _GameSetupWidgetState extends State<GameSetupWidget> {
  int _currentStep = 0;

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double heightAllExpansions = 200;
    const heightExpansion = heightAllExpansions - 25;
    const widthExpansion = heightExpansion * 0.72;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Stepper(
              stepIconMargin: EdgeInsets.zero,
              connectorColor: const WidgetStatePropertyAll(
                AppColors.greenDarker,
              ),
              steps: const [
                Step(
                  title: Text('Players', style: AppTextStyles.labelStep),
                  content: StepPlayerWidget(),
                ),
                Step(
                  title: Text(
                    'Expansions (work in progress)',
                    style: AppTextStyles.labelStep,
                  ),
                  content: StepExpansionWidget(
                    heightAllExpansions: heightAllExpansions,
                    heightExpansion: heightExpansion,
                    widthExpansion: widthExpansion,
                  ),
                ),
                Step(
                  title: Text(
                    'Modules (work in progress)',
                    style: AppTextStyles.labelStep,
                  ),
                  content: StepModuleWidget(),
                ),
              ],
              controlsBuilder: (_, details) => const SizedBox.shrink(),
              onStepTapped: _onStepTapped,
              currentStep: _currentStep,
            ),
          ),
        ),
        const StartButtonWidget(),
      ],
    );
  }
}
