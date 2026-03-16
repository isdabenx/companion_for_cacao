import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectModuleWidget extends ConsumerWidget {
  const SelectModuleWidget({required this.module, super.key});

  final ModuleModel module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSetupState = ref.watch(gameSetupProvider);
    final gameSetupNotifier = ref.read(gameSetupProvider.notifier);
    final isSelected = gameSetupState.modules.any((e) => e.id == module.id);

    void onToggleModule() {
      gameSetupNotifier.toggleModule(module);
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.brown,
              backgroundColor: isSelected
                  ? AppColors.greenDark
                  : AppColors.greenNormal,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onToggleModule,
            child: Text(module.name),
          ),
        ),
      ],
    );
  }
}
