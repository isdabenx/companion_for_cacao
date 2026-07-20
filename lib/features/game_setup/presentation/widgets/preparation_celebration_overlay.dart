import 'dart:math';

import 'package:collection/collection.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_copy.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fullscreen overlay shown when every preparation step is complete:
/// confetti, a closing message, an optional first-player draw and the
/// way back to the game dashboard.
class PreparationCelebrationOverlay extends ConsumerStatefulWidget {
  const PreparationCelebrationOverlay({required this.onClose, super.key});

  /// Dismisses the overlay without leaving the screen (e.g. to review
  /// or uncheck a step).
  final VoidCallback onClose;

  @override
  ConsumerState<PreparationCelebrationOverlay> createState() =>
      _PreparationCelebrationOverlayState();
}

class _PreparationCelebrationOverlayState
    extends ConsumerState<PreparationCelebrationOverlay> {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  /// Set once the user explicitly redraws. Until then the overlay
  /// announces the order already defined by dragging in Game Setup —
  /// the app's canonical first-player mechanism — instead of
  /// overriding it.
  bool _redrawn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      if (!MediaQuery.of(context).disableAnimations) {
        _confetti.play();
      }
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _drawFirstPlayer() {
    final drawn = ref.read(gameSetupProvider.notifier).drawRandomFirstPlayer();
    if (drawn == null) return;
    HapticFeedback.mediumImpact();
    setState(() => _redrawn = true);
  }

  @override
  Widget build(BuildContext context) {
    // First player = position 1 of the order dragged in Game Setup;
    // watching keeps the pill in sync when a redraw rotates the order.
    final firstPlayerName = ref.watch(
      gameSetupProvider.select((s) {
        final state = s.value;
        if (state == null) return null;
        final selected = state.players.where((p) => p.isSelected).toList();
        if (selected.isEmpty) return null;
        for (final color in state.colorOrder) {
          final player = selected.where((p) => p.color == color).firstOrNull;
          if (player != null) return player.displayName;
        }
        return selected.first.displayName;
      }),
    );

    return Positioned.fill(
      child: Material(
        color: AppColors.greenLight.withValues(alpha: 0.95),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              maxBlastForce: 25,
              minBlastForce: 8,
              emissionFrequency: 0.03,
              gravity: 0.25,
              colors: const [
                AppColors.greenDark,
                AppColors.gold,
                AppColors.red,
                AppColors.brown,
              ],
            ),
            Positioned(
              top: AppSpacing.s,
              right: AppSpacing.s,
              child: IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close, color: AppColors.brown),
                tooltip: 'Close',
              ),
            ),
            Center(
              child: Padding(
                padding: AppSpacing.allXl,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: -pi / 16,
                      child: const Text('🎉', style: TextStyle(fontSize: 56)),
                    ),
                    AppSpacing.verticalM,
                    Text(
                      PreparationCopy.allSetTitle,
                      style: AppTextStyles.titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalS,
                    Text(
                      PreparationCopy.allSetMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.brown),
                    ),
                    AppSpacing.verticalL,
                    if (firstPlayerName != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.l,
                          vertical: AppSpacing.s,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.gold),
                        ),
                        child: Text(
                          PreparationCopy.startsFirst(firstPlayerName),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      AppSpacing.verticalM,
                    ],
                    FilledButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: Text(PreparationCopy.backToGameAction),
                    ),
                    AppSpacing.verticalS,
                    // Random draw stays available for groups that did not
                    // settle an order in Game Setup — explicitly opt-in,
                    // because it rotates the defined turn order.
                    TextButton.icon(
                      onPressed: _drawFirstPlayer,
                      icon: const Icon(Icons.casino_outlined, size: 16),
                      label: Text(
                        _redrawn
                            ? PreparationCopy.drawAgainAction
                            : PreparationCopy.drawFirstPlayerAction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
