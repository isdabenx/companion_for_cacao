import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectExpansionWidget extends ConsumerWidget {
  const SelectExpansionWidget({
    required this.boardgame,
    required this.width,
    required this.height,
    super.key,
  });

  final double width;
  final double height;
  final BoardgameModel boardgame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      gameSetupProvider.select(
        (s) => s.value?.expansions.any((e) => e.id == boardgame.id) ?? false,
      ),
    );
    final gameSetupNotifier = ref.read(gameSetupProvider.notifier);

    void onToggleExpansion() {
      gameSetupNotifier.toggleExpansion(boardgame);
    }

    return GestureDetector(
      onTap: onToggleExpansion,
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent, width: 2),
              image: DecorationImage(
                image: AssetImage(
                  '${Assets.imagesBoardgamePath}${boardgame.filenameImage}',
                ),
                fit: BoxFit.cover,
                colorFilter: isSelected
                    ? null
                    : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            boardgame.name,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
