import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/domain/services/score_calculator_service.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/score_player_row_widget.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/safe_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gem Mines scoring: assign the mask tiles to their owners and count each
/// player's leftover gems (1 gold each).
class GemsStepWidget extends ConsumerWidget {
  const GemsStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap a mask tile and pick who owns it. Masks add their value in '
          'gold.',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,
        // Full width so the centered runs align with the screen, not with
        // the Wrap's own shrink-wrapped box.
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (var i = 0; i < ScoreCalculatorService.maskValues.length; i++)
                _MaskCard(maskIndex: i),
            ],
          ),
        ),
        AppSpacing.verticalXl,
        Text(
          'Leftover gems next to each village board (1 gold each):',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalS,
        for (final player in state.players)
          ScorePlayerRowWidget(
            player: player,
            trailing: CountStepperWidget(
              value: state.inputOf(player.color).leftoverGems,
              max: 32,
              allowDirectEntry: false,
              onChanged: (value) =>
                  notifier.setLeftoverGems(player.color, value),
            ),
          ),
      ],
    );
  }
}

/// Mask value drawn like the engraving on the physical tiles: a light gold
/// numeral with a dark outline, straight on the (blank) forehead plate.
class _EngravedValue extends StatelessWidget {
  const _EngravedValue({required this.value});

  final int value;

  static const _style = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w900,
    height: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outline pass
        Text(
          '$value',
          style: _style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = AppColors.brown,
          ),
        ),
        // Fill pass
        Text('$value', style: _style.copyWith(color: AppColors.gold)),
      ],
    );
  }
}

/// One mask tile: tapping opens a picker with the players (and a clear
/// option). The owner is shown with a tinted border and a color dot on the
/// mask's corner — a mask has at most one owner, so no dot row is needed.
class _MaskCard extends ConsumerWidget {
  const _MaskCard({required this.maskIndex});

  final int maskIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);
    final owner = state.maskOwners[maskIndex];
    final value = ScoreCalculatorService.maskValues[maskIndex];
    final ownerColor = owner != null ? AppColors.findColorByName(owner) : null;

    return PopupMenuButton<String>(
      tooltip: 'Assign mask',
      onSelected: (selected) =>
          notifier.setMaskOwner(maskIndex, selected.isEmpty ? null : selected),
      itemBuilder: (context) => [
        for (final player in state.players)
          PopupMenuItem(
            value: player.color,
            child: Row(
              children: [
                CircleBadge(
                  color: AppColors.findColorByName(player.color),
                  size: 20,
                ),
                AppSpacing.horizontalS,
                Text(player.displayName, style: AppTextStyles.markdownBody),
              ],
            ),
          ),
        if (owner != null)
          PopupMenuItem(
            value: '',
            child: Row(
              children: [
                const Icon(Icons.clear, size: 20, color: AppColors.red),
                AppSpacing.horizontalS,
                Text('Nobody', style: AppTextStyles.markdownBody),
              ],
            ),
          ),
      ],
      child: Container(
        // Compensate the thicker selected border so the card's outer size
        // never changes and the grid doesn't shift on selection.
        padding: EdgeInsets.all(
          ownerColor != null ? AppSpacing.s : AppSpacing.s + 1,
        ),
        decoration: BoxDecoration(
          color: ownerColor != null
              ? ownerColor.withValues(alpha: 0.15)
              : AppColors.white.withValues(alpha: 0.6),
          border: Border.all(
            color: ownerColor ?? AppColors.grey,
            width: ownerColor != null ? 2.5 : 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 56,
          height: 68,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: SafeAssetImage(
                  assetPath: Assets.preparationMasks,
                  fit: BoxFit.contain,
                ),
              ),
              // Value stamped on the blank forehead plate, mimicking the
              // engraved numbers of the printed tiles (light numeral with a
              // dark outline) instead of a UI badge over the art. The tiny
              // translation centers it on the plate, which sits slightly
              // left of the trimmed image's geometric center.
              Positioned(
                top: 12,
                child: Transform.translate(
                  offset: const Offset(1, 0),
                  child: _EngravedValue(value: value),
                ),
              ),
              if (ownerColor != null)
                Positioned(
                  right: -7,
                  bottom: -5,
                  child: CircleBadge(
                    color: ownerColor,
                    size: 22,
                    borderColor: AppColors.brown,
                    borderWidth: 1.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
