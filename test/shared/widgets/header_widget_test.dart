import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeaderWidget Widget Tests', () {
    testWidgets('renders text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HeaderWidget(text: 'Header Title')),
        ),
      );

      expect(find.byType(HeaderWidget), findsOneWidget);
      expect(find.text('Header Title'), findsOneWidget);
    });

    testWidgets('applies correct background color and text style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: HeaderWidget(text: 'Styled Header')),
        ),
      );

      final containerFinder = find
          .descendant(
            of: find.byType(HeaderWidget),
            matching: find.byType(Container),
          )
          .first;

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      final text = tester.widget<Text>(find.text('Styled Header'));

      // The header now leads with a gold accent bar (instead of a green
      // pill) next to bold body-font text.
      expect(decoration.color, AppColors.gold);
      expect(text.style, AppTextStyles.markdownH2);
    });
  });
}
