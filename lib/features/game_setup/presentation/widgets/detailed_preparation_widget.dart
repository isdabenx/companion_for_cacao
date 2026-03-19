import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/preparation_provider.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedPreparationWidget extends StatelessWidget {
  const DetailedPreparationWidget({required this.preparation, super.key});

  final List<PreparationEntity> preparation;

  @override
  Widget build(BuildContext context) {
    return ContainerFullStyleWidget(
      child: Column(
        children: [
          const HeaderWidget(text: 'Preparation'),
          Expanded(
            child: ListView.builder(
              itemCount: preparation.length,
              itemBuilder: (context, index) {
                return PreparationCard(
                  key: ValueKey(index),
                  preparation: preparation[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PreparationCard extends ConsumerWidget {
  const PreparationCard({
    required this.preparation,
    required this.index,
    super.key,
  });

  final PreparationEntity preparation;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completionMap = ref.watch(preparationCompletionProvider);
    final isCompleted = completionMap[index] ?? preparation.isCompleted;

    return Card(
      color: isCompleted ? AppColors.greenNormal : AppColors.greenDark,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            preparation.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: (preparation.color != null && !isCompleted)
                  ? AppColors.findColorByName(preparation.color!)
                  : AppColors.brown,
            ),
          ),
          leading: preparation.imagePath != null
              ? Image.asset(preparation.imagePath!)
              : null,
          onTap: () {
            ref
                .read(preparationCompletionProvider.notifier)
                .toggleCompletion(index, isCompleted);
          },
        ),
      ),
    );
  }
}
