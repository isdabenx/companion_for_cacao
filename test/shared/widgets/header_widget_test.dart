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

      expect(decoration.color, AppColors.greenNormal);
      expect(text.style, AppTextStyles.markdownH2);
    });
  });
}
