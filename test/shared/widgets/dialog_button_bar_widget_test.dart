import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/dialog_button_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The bar falls back to the localized OK/Cancel, so it needs the delegates.
Widget wrap(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  group('DialogButtonBarWidget Widget Tests', () {
    testWidgets('renders confirm and cancel buttons with default labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(DialogButtonBarWidget(onConfirm: () {}, onCancel: () {})),
      );

      expect(find.byType(DialogButtonBarWidget), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'OK'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    });

    testWidgets('renders with custom labels', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrap(
          DialogButtonBarWidget(
            confirmLabel: 'Yes',
            cancelLabel: 'No',
            onConfirm: () {},
            onCancel: () {},
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
        wrap(
          DialogButtonBarWidget(
            onConfirm: () => confirmTapped = true,
            onCancel: () {},
          ),
        ),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'OK'));
      await tester.pumpAndSettle();

      expect(confirmTapped, isTrue);
    });

    testWidgets('fires onCancel callback when cancel tapped', (
      WidgetTester tester,
    ) async {
      var cancelTapped = false;

      await tester.pumpWidget(
        wrap(
          DialogButtonBarWidget(
            onConfirm: () {},
            onCancel: () => cancelTapped = true,
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
        wrap(DialogButtonBarWidget(onConfirm: () {}, onCancel: () {})),
      );

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    // A confirm label that says what it does is longer than a dialog is
    // wide. An unconstrained Row painted it off the edge of the sheet; a
    // RenderFlex overflow fails the test, which is the point.
    testWidgets('a confirm label wider than the dialog does not overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 280,
            child: DialogButtonBarWidget(
              confirmLabel: 'Reinicia la puntuació de la partida',
              onConfirm: () {},
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
