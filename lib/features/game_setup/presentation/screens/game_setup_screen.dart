import 'package:companion_for_cacao/config/navigation/app_destinations.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/game_setup_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/dialog_button_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupScreen extends ConsumerWidget {
  const GameSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Clear lives in the app bar (not competing with the primary Start
    // button), and only shows once there is something to clear.
    final hasInput = ref.watch(
      gameSetupProvider.select((s) {
        final state = s.value;
        if (state == null) return false;
        return state.players.any((p) => p.isSelected) ||
            state.expansions.length > 1;
      }),
    );

    return CustomScaffoldWidget(
      destination: AppDestinationId.game,
      title: l10n.menuGame,
      actions: hasInput
          ? [
              Tooltip(
                message: l10n.clearSetup,
                child: IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => _confirmClear(context, ref),
                ),
              ),
            ]
          : null,
      body: const ContainerFullStyleWidget(child: GameSetupWidget()),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearSetup),
        content: Text(l10n.clearSetupBody),
        actions: [
          DialogButtonBarWidget(
            isDestructive: true,
            cancelLabel: l10n.cancelAction,
            confirmLabel: l10n.clearSetup,
            onCancel: () => Navigator.of(dialogContext).pop(false),
            onConfirm: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(gameSetupProvider.notifier).clearAll();
    }
  }
}
