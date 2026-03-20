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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  itemCount: preparation.length,
                  itemBuilder: (context, index) {
                    return PreparationCard(
                      key: ValueKey(preparation[index].id),
                      preparation: preparation[index],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreparationCard extends ConsumerWidget {
  const PreparationCard({required this.preparation, super.key});

  final PreparationEntity preparation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completionMap = ref.watch(preparationCompletionProvider);
    final isCompleted =
        completionMap[preparation.id] ?? preparation.isCompleted;

    return Card(
      color: isCompleted
          ? AppColors.greenNormal.withValues(alpha: 0.7)
          : AppColors.greenDark,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            preparation.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted
                  ? AppColors.brown.withValues(alpha: 0.5)
                  : (preparation.color != null
                        ? AppColors.findColorByName(preparation.color!)
                        : AppColors.brown),
            ),
          ),
          leading: preparation.imagePath != null
              ? SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(preparation.imagePath!),
                )
              : null,
          trailing: Checkbox(
            value: isCompleted,
            onChanged: (_) {
              ref
                  .read(preparationCompletionProvider.notifier)
                  .toggleCompletion(preparation.id);
            },
            activeColor: AppColors.brown,
          ),
          onTap: () {
            ref
                .read(preparationCompletionProvider.notifier)
                .toggleCompletion(preparation.id);
          },
        ),
      ),
    );
  }
}
