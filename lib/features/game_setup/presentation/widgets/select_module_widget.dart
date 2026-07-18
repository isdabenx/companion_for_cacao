import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectModuleWidget extends ConsumerWidget {
  const SelectModuleWidget({required this.module, super.key});

  final ModuleEntity module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      gameSetupProvider.select(
        (s) => s.value?.modules.any((e) => e.id == module.id) ?? false,
      ),
    );
    void onToggleModule() {
      ref.read(gameSetupProvider.notifier).toggleModule(module);
    }

    return Row(
      children: [
        Flexible(
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
