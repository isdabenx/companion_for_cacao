import 'package:companion_for_cacao/shared/widgets/dialog_button_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DialogButtonBarWidget Widget Tests', () {
    testWidgets('renders confirm and cancel buttons with default labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogButtonBarWidget(onConfirm: () {}, onCancel: () {}),
          ),
        ),
      );

      expect(find.byType(DialogButtonBarWidget), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Confirm'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    });

    testWidgets('renders with custom labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogButtonBarWidget(
              confirmLabel: 'Yes',
              cancelLabel: 'No',
              onConfirm: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.widgetWithText(FilledButton, 'Yes'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'No'), findsOneWidget);
    });

    testWidgets('fires onConfirm callback when confirm tapped', (
      WidgetTester tester,
    ) async {
      var confirmTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogButtonBarWidget(
              onConfirm: () => confirmTapped = true,
              onCancel: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Confirm'));
      await tester.pumpAndSettle();

      expect(confirmTapped, isTrue);
    });

    testWidgets('fires onCancel callback when cancel tapped', (
      WidgetTester tester,
    ) async {
      var cancelTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogButtonBarWidget(
              onConfirm: () {},
              onCancel: () => cancelTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(cancelTapped, isTrue);
    });

    testWidgets('has FilledButton for confirm and TextButton for cancel', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DialogButtonBarWidget(onConfirm: () {}, onCancel: () {}),
          ),
        ),
      );

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
