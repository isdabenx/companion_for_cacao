import 'package:collection/collection.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_fonts.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/preparation_provider.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedPreparationWidget extends ConsumerWidget {
  const DetailedPreparationWidget({required this.preparation, super.key});

  final List<PreparationEntity> preparation;

  String _getPhaseName(PreparationPhase phase) {
    switch (phase) {
      case PreparationPhase.tilePool:
        return 'Tile Pool';
      case PreparationPhase.playerSetup:
        return 'Player Setup';
      case PreparationPhase.boardSetup:
        return 'Board Setup';
      case PreparationPhase.supplies:
        return 'Supplies';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completionMap = ref.watch(preparationCompletionProvider);
    final completedCount = preparation
        .where((p) => completionMap[p.id] ?? p.isCompleted)
        .length;
    final progress = preparation.isEmpty
        ? 0.0
        : completedCount / preparation.length;

    final groupedPreparation = groupBy(preparation, (p) => p.phase);

    return ContainerFullStyleWidget(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontFamily: AppFonts.headerFont,
                              color: AppColors.brown,
                            ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontFamily: AppFonts.headerFont,
                              color: AppColors.brown,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.brown.withValues(alpha: 0.15),
                    color: AppColors.brown,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  itemCount: groupedPreparation.length,
                  itemBuilder: (context, index) {
                    final phase = groupedPreparation.keys.elementAt(index);
                    final items = groupedPreparation[phase]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getPhaseName(phase),
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontFamily: AppFonts.headerFont,
                                      color: AppColors.brown,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              const Divider(
                                color: AppColors.brown,
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                        ...items.map(
                          (item) => PreparationCard(
                            key: ValueKey(item.id),
                            preparation: item,
                          ),
                        ),
                      ],
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

    return Opacity(
      opacity: isCompleted ? 0.6 : 1.0,
      child: Card(
        color: AppColors.cream,
        elevation: isCompleted ? 0 : 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.brown.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ref
                .read(preparationCompletionProvider.notifier)
                .toggleCompletion(preparation.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (preparation.color != null)
                  Container(
                    width: 12,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.findColorByName(preparation.color!),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                if (preparation.imagePath != null)
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brown.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          preparation.imagePath!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    preparation.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.brown,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: AppColors.brown,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
