import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContainerFullStyleWidget Widget Tests', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContainerFullStyleWidget(child: Text('Child Content')),
          ),
        ),
      );

      expect(find.byType(ContainerFullStyleWidget), findsOneWidget);
      expect(find.text('Child Content'), findsOneWidget);
    });

    testWidgets('applies full style decoration and width infinity', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ContainerFullStyleWidget(child: Text('Styled Child')),
          ),
        ),
      );

      final containerFinder = find
          .descendant(
            of: find.byType(ContainerFullStyleWidget),
            matching: find.byType(Container),
          )
          .first;

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      final borderRadius = decoration.borderRadius as BorderRadius;

      expect(tester.getSize(containerFinder).width, 800);
      expect(decoration.color, AppColors.greenLight);
      expect(border.top.color, AppColors.greenDarker);
      expect(border.top.width, 4);
      expect(borderRadius, BorderRadius.circular(24));
    });
  });
}
