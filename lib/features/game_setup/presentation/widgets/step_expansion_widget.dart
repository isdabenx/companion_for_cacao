import 'package:companion_for_cacao/features/game_setup/presentation/widgets/select_expansion_widget.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter/foundation.dart';
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
              final boardgamesAsync = ref.watch(boardgameProvider);

              return boardgamesAsync.when(
                data: (boardgames) {
                  final expansions = boardgames
                      .where((element) => element.id != 1)
                      .toList();

                  final isDesktop =
                      kIsWeb ||
                      defaultTargetPlatform == TargetPlatform.windows ||
                      defaultTargetPlatform == TargetPlatform.macOS ||
                      defaultTargetPlatform == TargetPlatform.linux;

                  return Scrollbar(
                    thumbVisibility: isDesktop,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: expansions.length,
                      padding: EdgeInsets.only(bottom: isDesktop ? 12 : 0),
                      itemBuilder: (context, index) {
                        return SelectExpansionWidget(
                          key: ValueKey(expansions[index].id),
                          boardgame: expansions[index],
                          height: heightExpansion,
                          width: widthExpansion,
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              );
            },
          ),
        ),
      ],
    );
  }
}
