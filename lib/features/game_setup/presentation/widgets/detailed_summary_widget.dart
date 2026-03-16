import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class DetailedSummaryWidget extends StatelessWidget {
  const DetailedSummaryWidget({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;
  @override
  Widget build(BuildContext context) {
    return ContainerFullStyleWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderWidget(text: 'Players'),
            Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                TableRow(
                  children: [
                    const LeftTextCell(text: 'Quantity:'),
                    RightTextCell(text: gameSetup.players.length.toString()),
                  ],
                ),
                TableRow(
                  children: [
                    const LeftTextCell(text: 'Names:'),
                    RightTextCell(
                      text: gameSetup.players.map((e) => e.name).join(', '),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const LeftTextCell(text: 'Colors:'),
                    RightTextCell(
                      text: gameSetup.players.map((e) => e.color).join(', '),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const HeaderWidget(text: 'Game & Expansions'),
            Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                TableRow(
                  children: [
                    const LeftTextCell(text: 'Quantity:'),
                    RightTextCell(text: gameSetup.expansions.length.toString()),
                  ],
                ),
                TableRow(
                  children: [
                    const LeftTextCell(text: 'Names:'),
                    RightTextCell(
                      text: gameSetup.expansions.map((e) => e.name).join(', '),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const HeaderWidget(text: 'Modules'),
            Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                TableRow(
                  children: [
                    const LeftTextCell(text: 'Quantity:'),
                    RightTextCell(text: gameSetup.modules.length.toString()),
                  ],
                ),
                if (gameSetup.modules.isNotEmpty)
                  TableRow(
                    children: [
                      const LeftTextCell(text: 'Names:'),
                      RightTextCell(
                        text: gameSetup.modules.map((e) => e.name).join(', '),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const HeaderWidget(text: 'Tiles'),
            Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                for (final tile in gameSetup.tiles)
                  TableRow(
                    children: [
                      LeftTextCell(
                        text: (tile.color != null)
                            ? '${tile.name} (${tile.color.toString().split('.').last})'
                            : tile.name,
                      ),
                      RightTextCell(text: tile.quantity.toString()),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LeftCell extends StatelessWidget {
  const LeftCell({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Align(alignment: Alignment.centerRight, child: child),
    );
  }
}

class LeftTextCell extends StatelessWidget {
  const LeftTextCell({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return LeftCell(
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class RightCell extends StatelessWidget {
  const RightCell({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }
}

class RightTextCell extends StatelessWidget {
  const RightTextCell({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return RightCell(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
      ),
    );
  }
}
