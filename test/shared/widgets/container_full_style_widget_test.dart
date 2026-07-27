import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_corner/smooth_corner.dart';

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
      final decoration = container.decoration as ShapeDecoration;

      expect(tester.getSize(containerFinder).width, 800);
      // Warm content surface with a soft shadow and a squircle shape —
      // the calmed panel that replaced the hard green-bordered box.
      expect(decoration.color, AppColors.surface);
      expect(decoration.shape, isA<SmoothRectangleBorder>());
      expect(decoration.shadows, isNotEmpty);
    });
  });
}
