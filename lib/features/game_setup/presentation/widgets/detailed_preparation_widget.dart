import 'package:collection/collection.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_fonts.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/utils/preparation_image_resolver.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detailed_preparation_widget.g.dart';

// Local provider for phase expansion state
@riverpod
class PhaseExpansion extends _$PhaseExpansion {
  @override
  Map<PreparationPhase, bool> build() {
    return {};
  }

  void toggle(PreparationPhase phase) {
    state = {...state, phase: !(state[phase] ?? false)};
  }

  void clearAll() {
    state = {};
  }
}

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
    final gameSetup = ref.watch(gameSetupProvider).value;
    final completionMap = Map<String, bool>.fromEntries(
      gameSetup?.preparation.map((p) => MapEntry(p.id, p.isCompleted)) ?? [],
    );
    final expansionMap = ref.watch(phaseExpansionProvider);
    final groupedPreparation = groupBy(preparation, (p) => p.phase);

    PreparationPhase? firstIncompletePhase;
    for (final entry in groupedPreparation.entries) {
      final items = entry.value;
      final completedCount = items
          .where((p) => completionMap[p.id] ?? p.isCompleted)
          .length;
      if (items.isNotEmpty && completedCount < items.length) {
        firstIncompletePhase = entry.key;
        break;
      }
    }

    return ContainerFullStyleWidget(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CustomScrollView(
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 16.0)),
              for (final entry in groupedPreparation.entries)
                SliverMainAxisGroup(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _PhaseHeaderDelegate(
                        phase: entry.key,
                        phaseName: _getPhaseName(entry.key),
                        items: entry.value,
                        completionMap: completionMap,
                        isExpanded:
                            expansionMap[entry.key] ??
                            (entry.key == firstIncompletePhase),
                        onTap: () {
                          ref
                              .read(phaseExpansionProvider.notifier)
                              .toggle(entry.key);
                        },
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final items = entry.value;

                        final isDefaultExpanded =
                            entry.key == firstIncompletePhase;
                        final isExpanded =
                            expansionMap[entry.key] ?? isDefaultExpanded;

                        if (!isExpanded) {
                          return const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = items[index];
                            return PreparationCard(
                              key: ValueKey(item.id),
                              preparation: item,
                            );
                          }, childCount: items.length),
                        );
                      },
                    ),
                  ],
                ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhaseHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PhaseHeaderDelegate({
    required this.phase,
    required this.phaseName,
    required this.items,
    required this.completionMap,
    required this.isExpanded,
    required this.onTap,
  });

  final PreparationPhase phase;
  final String phaseName;
  final List<PreparationEntity> items;
  final Map<String, bool> completionMap;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final phaseCompletedCount = items
        .where((p) => completionMap[p.id] ?? p.isCompleted)
        .length;
    final phaseTotalCount = items.length;
    final isPhaseCompleted =
        phaseTotalCount > 0 && phaseCompletedCount == phaseTotalCount;
    final phaseProgress = phaseTotalCount == 0
        ? 0.0
        : phaseCompletedCount / phaseTotalCount;

    return Material(
      color: AppColors.greenLight,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  phaseName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: AppFonts.headerFont,
                    color: AppColors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isPhaseCompleted)
                const Icon(Icons.check_circle, color: AppColors.brown, size: 24)
              else ...[
                Text(
                  '$phaseCompletedCount / $phaseTotalCount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: phaseProgress,
                    backgroundColor: AppColors.brown.withValues(alpha: 0.15),
                    color: AppColors.brown,
                    strokeWidth: 3,
                  ),
                ),
              ],
              const SizedBox(width: 12),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.brown,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant _PhaseHeaderDelegate oldDelegate) {
    return phaseName != oldDelegate.phaseName ||
        items != oldDelegate.items ||
        completionMap != oldDelegate.completionMap ||
        isExpanded != oldDelegate.isExpanded;
  }
}

class PreparationCard extends ConsumerWidget {
  const PreparationCard({required this.preparation, super.key});

  final PreparationEntity preparation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSetup = ref.watch(gameSetupProvider).value;
    final isCompleted =
        gameSetup?.preparation
            .firstWhere((p) => p.id == preparation.id)
            .isCompleted ??
        preparation.isCompleted;

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
                .read(gameSetupProvider.notifier)
                .togglePreparationCompletion(preparation.id);
            ref.read(phaseExpansionProvider.notifier).clearAll();
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
                if (preparation.imageKey != null)
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
                          preparation.imageKey!.toAssetPath(),
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
