import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/select_module_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepModuleWidget extends ConsumerWidget {
  const StepModuleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(
      gameSetupProvider.select(
        (s) =>
            s.value?.expansions
                .map((e) => e.modules)
                .expand((element) => element)
                .toList() ??
            [],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select the modules you're playing with"),
        Column(
          children: [
            if (modules.isEmpty)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'No expansion with modules are selected',
                        style: AppTextStyles.boardgameTitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            for (final ModuleModel module in modules)
              SelectModuleWidget(module: module),
          ],
        ),
      ],
    );
  }
}
