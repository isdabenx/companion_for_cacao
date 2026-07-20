import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/utils/preparation_image_resolver.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_image_dialog.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_step_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Card that renders every step of a preparation group (a player's
/// corner) as expandable rows, tinted with the player color, with a
/// master check that completes the whole group at once.
class PreparationGroupCard extends ConsumerWidget {
  const PreparationGroupCard({
    required this.groupId,
    required this.title,
    required this.steps,
    this.colorName,
    this.initiallyExpandedRows = false,
    super.key,
  });

  final String groupId;

  /// Header title: the player's display name (or a generic group title).
  final String title;

  final List<PreparationEntity> steps;

  /// Player color name for the tint and avatar. Null renders neutral.
  final String? colorName;

  final bool initiallyExpandedRows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completionByid = ref.watch(
      gameSetupProvider.select(
        (s) => Map<String, bool>.fromEntries(
          s.value?.preparation
                  .where((p) => p.groupId == groupId)
                  .map((p) => MapEntry(p.id, p.isCompleted)) ??
              const [],
        ),
      ),
    );
    bool completed(PreparationEntity step) =>
        completionByid[step.id] ?? step.isCompleted;
    final completedCount = steps.where(completed).length;
    final allCompleted = completedCount == steps.length && steps.isNotEmpty;

    final Color tint = colorName != null
        ? AppColors.findColorByName(colorName!)
        : AppColors.brown;
    final Color cardColor = Color.alphaBlend(
      tint.withValues(alpha: 0.10),
      AppColors.cream,
    );

    return Card(
      color: cardColor,
      elevation: allCompleted ? 0 : 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: tint.withValues(alpha: 0.55), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.s,
          AppSpacing.m,
          AppSpacing.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Opacity(
              opacity: allCompleted ? 0.55 : 1.0,
              child: Row(
                children: [
                  if (colorName != null) ...[
                    _PlayerAvatar(colorName: colorName!, title: title),
                    AppSpacing.horizontalM,
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                  Text(
                    '$completedCount/${steps.length}',
                    style: AppTextStyles.phaseCounter.copyWith(fontSize: 13),
                  ),
                  AppSpacing.horizontalM,
                  InkResponse(
                    onTap: () => ref
                        .read(gameSetupProvider.notifier)
                        .toggleGroupCompletion(groupId),
                    radius: 24,
                    child: Icon(
                      allCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: AppColors.brown,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: AppSpacing.m,
              thickness: 1,
              color: tint.withValues(alpha: 0.25),
            ),
            for (final (index, step) in steps.indexed) ...[
              if (index > 0)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.brown.withValues(alpha: 0.08),
                ),
              PreparationStepRow(
                key: ValueKey(step.id),
                step: step,
                initiallyExpanded: initiallyExpandedRows,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  const _PlayerAvatar({required this.colorName, required this.title});

  final String colorName;
  final String title;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.findColorByName(colorName);
    // Dark colors get a light initial and vice versa, so the letter is
    // readable regardless of the player color (also matters for
    // color-blind users: the name and initial carry the identity).
    final onColor = color.computeLuminance() > 0.5
        ? AppColors.brown
        : AppColors.white;

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.brown.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        title.isNotEmpty ? title.characters.first.toUpperCase() : '?',
        style: TextStyle(
          color: onColor,
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      ),
    );
  }
}

/// Card for the shared "return to the box" group: a grid of the removed
/// tiles with their quantities, each individually checkable, plus a
/// master check for the whole batch.
class ReturnToBoxCard extends ConsumerWidget {
  const ReturnToBoxCard({
    required this.groupId,
    required this.title,
    required this.subtitle,
    required this.steps,
    super.key,
  });

  final String groupId;
  final String title;
  final String subtitle;
  final List<PreparationEntity> steps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completionByid = ref.watch(
      gameSetupProvider.select(
        (s) => Map<String, bool>.fromEntries(
          s.value?.preparation
                  .where((p) => p.groupId == groupId)
                  .map((p) => MapEntry(p.id, p.isCompleted)) ??
              const [],
        ),
      ),
    );
    bool completed(PreparationEntity step) =>
        completionByid[step.id] ?? step.isCompleted;
    final completedCount = steps.where(completed).length;
    final allCompleted = completedCount == steps.length && steps.isNotEmpty;

    return Card(
      color: AppColors.cream,
      elevation: allCompleted ? 0 : 2,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.brown.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: AppSpacing.allM,
        child: Opacity(
          opacity: allCompleted ? 0.55 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.brown,
                    ),
                  ),
                  AppSpacing.horizontalM,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.brown,
                              ),
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.brown.withValues(alpha: 0.6),
                                fontSize: 11.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$completedCount/${steps.length}',
                    style: AppTextStyles.phaseCounter.copyWith(fontSize: 13),
                  ),
                  AppSpacing.horizontalM,
                  InkResponse(
                    onTap: () => ref
                        .read(gameSetupProvider.notifier)
                        .toggleGroupCompletion(groupId),
                    radius: 24,
                    child: Icon(
                      allCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: AppColors.brown,
                      size: 28,
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalS,
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.s,
                crossAxisSpacing: AppSpacing.s,
                children: [
                  for (final step in steps)
                    _RemovalTileCell(
                      key: ValueKey(step.id),
                      step: step,
                      isCompleted: completed(step),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemovalTileCell extends ConsumerWidget {
  const _RemovalTileCell({
    required this.step,
    required this.isCompleted,
    super.key,
  });

  final PreparationEntity step;
  final bool isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: step.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => ref
            .read(gameSetupProvider.notifier)
            .togglePreparationCompletion(step.id),
        onLongPress: step.imageKey != null
            ? () => showPreparationImageDialog(
                context,
                imagePath: step.imageKey!.toAssetPath(),
                heroTag: 'prep_image_${step.id}',
              )
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.greenDark
                      : AppColors.brown.withValues(alpha: 0.2),
                  width: isCompleted ? 2 : 1,
                ),
              ),
              padding: const EdgeInsets.all(6),
              alignment: Alignment.center,
              child: step.imageKey != null
                  ? Opacity(
                      opacity: isCompleted ? 0.45 : 1.0,
                      child: Hero(
                        tag: 'prep_image_${step.id}',
                        child: Image.asset(
                          step.imageKey!.toAssetPath(),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.brown,
                              ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.brown.withValues(alpha: 0.5),
                    ),
            ),
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.brown,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.cream, width: 1.5),
                ),
                child: Text(
                  step.quantity != null ? '×${step.quantity}' : 'ALL',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (isCompleted)
              const Positioned(
                bottom: 4,
                right: 4,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.greenDark,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
