import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/shared/utils/hut_type_assets.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/safe_asset_image.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Huts built by each player. Costs are refunded automatically; Hermit and
/// Road Worker ask for their manual board counts when selected.
class HutsStepWidget extends ConsumerWidget {
  const HutsStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mark the huts each player built. Building costs are refunded and '
          'bonuses added automatically. Huts are limited physical tiles: a '
          'grayed-out hut has no tile left (deselect it from its owner to '
          'reassign it).',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,
        for (final player in state.players) _PlayerHutsPanel(player: player),
      ],
    );
  }
}

class _PlayerHutsPanel extends ConsumerWidget {
  const _PlayerHutsPanel({required this.player});

  final PlayerEntity player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = player.color;
    final input = ref.watch(scoreProvider.select((s) => s.inputOf(color)));
    final notifier = ref.read(scoreProvider.notifier);

    return Card(
      color: AppColors.white.withValues(alpha: 0.6),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: ExpansionTile(
        shape: const Border(),
        leading: CircleBadge(color: AppColors.findColorByName(color), size: 28),
        title: Text(
          player.displayName,
          style: AppTextStyles.markdownBody.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${input.huts.length} huts',
          style: AppTextStyles.sectionSublabel,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          0,
          AppSpacing.m,
          AppSpacing.m,
        ),
        children: [
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final hut in HutType.values)
                _HutChip(hut: hut, owner: color),
            ],
          ),
          if (input.huts.contains(HutType.hermit)) ...[
            AppSpacing.verticalM,
            _ManualCountRow(
              label: 'Hermit: own workers with no adjacent jungle tile',
              value: input.hermitWorkers,
              onChanged: (value) => notifier.setHermitWorkers(color, value),
            ),
          ],
          if (input.huts.contains(HutType.roadWorker)) ...[
            AppSpacing.verticalM,
            _ManualCountRow(
              label: 'Road Worker: worker tiles in your best row or column',
              value: input.roadWorkerTiles,
              onChanged: (value) => notifier.setRoadWorkerTiles(color, value),
            ),
          ],
        ],
      ),
    );
  }
}

/// One hut chip inside a player's panel. Huts are physical double-sided
/// tiles: other players holding this function are shown as color circles,
/// and the chip is disabled when no real tile could still provide it (the
/// supply is exhausted or the tile's other side is already in play).
class _HutChip extends ConsumerWidget {
  const _HutChip({required this.hut, required this.owner});

  final HutType hut;

  /// Color of the player whose panel this chip belongs to.
  final String owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);
    final isMine = state.inputOf(owner).huts.contains(hut);
    final otherOwners = state.hutOwners(hut).where((c) => c != owner);
    final isBlocked = !isMine && !state.canBuildHut(owner, hut);

    return SelectableChip(
      isSelected: isMine,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      onTap: isBlocked ? null : () => notifier.toggleHut(owner, hut),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: isBlocked ? 0.4 : 1,
            child: SafeAssetImage(
              assetPath: hut.imageAsset,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
          AppSpacing.horizontalS,
          for (final otherColor in otherOwners) ...[
            CircleBadge(
              color: AppColors.findColorByName(otherColor),
              size: 14,
              borderWidth: 1,
            ),
            AppSpacing.horizontalS,
          ],
          Text(
            '${hut.label} (${hut.cost})',
            style: AppTextStyles.tileNameSmall.copyWith(
              color: isBlocked
                  ? AppColors.brown.withValues(alpha: 0.4)
                  : AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualCountRow extends StatelessWidget {
  const _ManualCountRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.instruction)),
        CountStepperWidget(
          value: value,
          max: 20,
          allowDirectEntry: false,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
