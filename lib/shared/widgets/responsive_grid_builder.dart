import 'package:flutter/material.dart';

class ResponsiveGridBuilder extends StatelessWidget {
  const ResponsiveGridBuilder({
    required this.itemCount,
    required this.itemBuilder,
    required this.minItemWidth,
    this.minColumns = 1,
    this.maxColumns = 4,
    this.horizontalSpacing = 12.0,
    this.verticalSpacing = 8.0,
    super.key,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double minItemWidth;
  final int minColumns;
  final int maxColumns;
  final double horizontalSpacing;
  final double verticalSpacing;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minItemWidth).floor().clamp(
          minColumns,
          maxColumns,
        );
        final rows = (itemCount / columns).ceil();

        return Table(
          columnWidths: {
            for (int i = 0; i < columns; i++) i: const FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: [
            for (int row = 0; row < rows; row++)
              TableRow(
                children: [
                  for (int col = 0; col < columns; col++)
                    col < (itemCount - row * columns)
                        ? Padding(
                            padding: EdgeInsets.only(
                              right: col < columns - 1 ? horizontalSpacing : 0,
                              bottom: row < rows - 1 ? verticalSpacing : 0,
                            ),
                            child: itemBuilder(context, row * columns + col),
                          )
                        : const SizedBox.shrink(),
                ],
              ),
          ],
        );
      },
    );
  }
}
