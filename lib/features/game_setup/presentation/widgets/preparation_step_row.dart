import 'package:collection/collection.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/color_filters.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/utils/preparation_image_resolver.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_image_dialog.dart';
import 'package:companion_for_cacao/shared/widgets/players_color_bar.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One preparation step as an expandable row: thumbnail + short label
/// (WHAT) + check, expanding to the full instruction (HOW) and its
/// optional rationale (WHY).
///
/// Touch zones (spec-fase-ux1 §4): the image zooms, the check completes,
/// the rest of the row expands/collapses.
class PreparationStepRow extends ConsumerStatefulWidget {
  const PreparationStepRow({
    required this.step,
    this.initiallyExpanded = false,
    this.isCompletedOverride,
    this.onCheckTap,
    super.key,
  });

  final PreparationEntity step;

  /// First-ever preparation on this device starts expanded so new
  /// players see the full instructions without any interaction.
  final bool initiallyExpanded;

  /// Overrides the stored completion with a derived one (e.g. the hut
  /// throw, completed by registering the result).
  final bool? isCompletedOverride;

  /// Replaces the default check behavior (toggling completion by id).
  final VoidCallback? onCheckTap;

  @override
  ConsumerState<PreparationStepRow> createState() => _PreparationStepRowState();
}

class _PreparationStepRowState extends ConsumerState<PreparationStepRow> {
  late bool _expanded = widget.initiallyExpanded;

  String get _heroTag => 'prep_image_${widget.step.id}';

  IconData get _fallbackIcon => switch (widget.step.tableZone) {
    TableZone.playerArea => Icons.person_outline,
    TableZone.junglePile => Icons.layers_outlined,
    TableZone.jungleDisplay => Icons.style_outlined,
    TableZone.supplies => Icons.category_outlined,
    TableZone.startingArea => Icons.grid_view_outlined,
    TableZone.box => Icons.inventory_2_outlined,
  };

  void _onCheckTap() {
    if (widget.onCheckTap != null) {
      widget.onCheckTap!();
      return;
    }
    HapticFeedback.lightImpact();
    ref
        .read(gameSetupProvider.notifier)
        .togglePreparationCompletion(widget.step.id);
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    // firstWhereOrNull: the list can be regenerated while a row with a
    // stale id is still mounted — a missing id must not throw.
    final bool? storedCompleted = ref.watch(
      gameSetupProvider.select(
        (s) => s.value?.preparation
            .firstWhereOrNull((p) => p.id == step.id)
            ?.isCompleted,
      ),
    );
    final isCompleted =
        widget.isCompletedOverride ?? storedCompleted ?? step.isCompleted;

    // "Each player…" steps: show a colour bar of who does it, and grey out
    // the reference (white) component art.
    final isAllPlayers = step.actor == PreparationActor.allPlayers;
    final isGrayscale = isAllPlayers && step.colorReferenceImage;
    final playersKey = ref.watch(
      gameSetupProvider.select(
        (s) => (s.value?.players.map((p) => p.color) ?? const <String>[]).join(
          ',',
        ),
      ),
    );
    final playerColors = isAllPlayers && playersKey.isNotEmpty
        ? playersKey.split(',')
        : const <String>[];

    return Opacity(
      opacity: isCompleted ? 0.55 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (playerColors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: AppSpacing.xs),
              child: PlayersColorBar(colors: playerColors),
            ),
          InkWell(
            borderRadius: AppShapes.radius(AppShapes.radiusM),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  _Thumb(
                    imageKey: step.imageKey,
                    quantity: step.quantity,
                    fallbackIcon: _fallbackIcon,
                    grayscale: isGrayscale,
                    size: _expanded ? 64 : 42,
                    onTap: step.imageKey != null
                        ? () => showPreparationImageDialog(
                            context,
                            imagePath: step.imageKey!.toAssetPath(),
                            heroTag: _heroTag,
                            grayscale: isGrayscale,
                          )
                        : null,
                    heroTag: _heroTag,
                  ),
                  AppSpacing.horizontalM,
                  Expanded(
                    child: Text(
                      step.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                  AppSpacing.horizontalS,
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      size: 20,
                      color: AppColors.brown.withValues(alpha: 0.5),
                    ),
                  ),
                  AppSpacing.horizontalS,
                  // Informational steps (e.g. "if you store this expansion
                  // mixed in…") carry guidance, not a task, so they show an
                  // info glyph instead of a checkbox and can't be ticked.
                  if (step.informational)
                    Icon(
                      Icons.info_outline,
                      size: 24,
                      color: AppColors.brown.withValues(alpha: 0.4),
                    )
                  else
                    InkResponse(
                      onTap: _onCheckTap,
                      radius: 24,
                      child: AnimatedCheckIcon(isCompleted: isCompleted),
                    ),
                ],
              ),
            ),
          ),
          // Extra tile faces (e.g. the ones a mixed-storage note asks to take
          // out), shown as a strip so they're recognised without expanding.
          if (step.imageStrip.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 54, bottom: AppSpacing.xs),
              child: Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final tile in step.imageStrip)
                    _MiniTile(imageKey: tile.imageKey, quantity: tile.quantity),
                ],
              ),
            ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.s,
                right: AppSpacing.s,
                bottom: AppSpacing.s,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.detail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.brown.withValues(alpha: 0.85),
                      height: 1.35,
                    ),
                  ),
                  if (step.rationale != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 14,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            step.rationale!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.brown.withValues(alpha: 0.6),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 11.5,
                                  height: 1.3,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Completion check that plays a short "pop" whenever the state flips
/// to completed. The key swap restarts the tween only on real changes,
/// so rebuilds are free; disabled animations skip the pop entirely.
class AnimatedCheckIcon extends StatelessWidget {
  const AnimatedCheckIcon({
    required this.isCompleted,
    this.size = 26,
    super.key,
  });

  final bool isCompleted;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      isCompleted ? Icons.check_circle : Icons.circle_outlined,
      color: AppColors.brown,
      size: size,
    );
    if (!isCompleted || MediaQuery.of(context).disableAnimations) {
      return icon;
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey(isCompleted),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      builder: (context, t, child) {
        // 1 → 1.35 → 1 bump along the tween.
        final scale = 1 + (t < 0.5 ? t : 1 - t) * 0.7;
        return Transform.scale(scale: scale, child: child);
      },
      child: icon,
    );
  }
}

/// A small tile face shown in a step's image strip (e.g. the tiles a
/// mixed-storage note asks to take out). Tappable to zoom.
class _MiniTile extends StatelessWidget {
  const _MiniTile({required this.imageKey, required this.quantity});

  final String imageKey;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPreparationImageDialog(
        context,
        imagePath: imageKey.toAssetPath(),
        heroTag: 'prep_mini_$imageKey',
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppShapes.radius(AppShapes.radiusM),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brown.withValues(alpha: 0.12),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              imageKey.toAssetPath(),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.brown.withValues(alpha: 0.5),
                size: 20,
              ),
            ),
          ),
          if (quantity >= 1)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.brown,
                  borderRadius: AppShapes.radius(AppShapes.pill),
                  border: Border.all(color: AppColors.cream, width: 1.5),
                ),
                child: Text(
                  '×$quantity',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Step thumbnail: the real asset when available (tappable to zoom, with
/// a visible magnifier affordance) or a zone icon otherwise. Grows when
/// the row expands.
class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.imageKey,
    required this.quantity,
    required this.fallbackIcon,
    required this.size,
    required this.heroTag,
    this.onTap,
    this.grayscale = false,
  });

  final String? imageKey;
  final int? quantity;
  final IconData fallbackIcon;
  final double size;
  final String heroTag;
  final VoidCallback? onTap;
  final bool grayscale;

  @override
  Widget build(BuildContext context) {
    final Widget content = imageKey != null
        ? Hero(
            tag: heroTag,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppShapes.radius(AppShapes.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brown.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: grayscale
                  ? ColorFiltered(
                      colorFilter: kGrayscaleFilter,
                      child: Image.asset(
                        imageKey!.toAssetPath(),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.brown,
                          size: size * 0.5,
                        ),
                      ),
                    )
                  : Image.asset(
                      imageKey!.toAssetPath(),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.brown,
                        size: size * 0.5,
                      ),
                    ),
            ),
          )
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.6),
              borderRadius: AppShapes.radius(AppShapes.radiusM),
            ),
            child: Icon(
              fallbackIcon,
              color: AppColors.brown.withValues(alpha: 0.6),
              size: size * 0.5,
            ),
          );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            content,
            if (quantity != null && quantity! >= 1)
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brown,
                    borderRadius: AppShapes.radius(AppShapes.pill),
                    border: Border.all(color: AppColors.cream, width: 1.5),
                  ),
                  child: Text(
                    '×$quantity',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (onTap != null)
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.greenDarker,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
