import 'package:companion_for_cacao/features/game_setup/presentation/widgets/select_expansion_widget.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepExpansionWidget extends StatelessWidget {
  const StepExpansionWidget({
    required this.heightAllExpansions,
    required this.heightExpansion,
    required this.widthExpansion,
    super.key,
  });

  final double heightAllExpansions;
  final double heightExpansion;
  final double widthExpansion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text("Select the expansions you're playing with"),
        ),
        SizedBox(
          height: heightAllExpansions,
          child: Consumer(
            builder: (context, ref, child) {
              final boardgames = ref
                  .watch(boardgameProvider)
                  .where((element) => element.id != 1)
                  .toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: boardgames.length,
                itemBuilder: (context, index) {
                  return SelectExpansionWidget(
                    key: ValueKey(boardgames[index].id),
                    boardgame: boardgames[index],
                    height: heightExpansion,
                    width: widthExpansion,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
