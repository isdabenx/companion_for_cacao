import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CountStepperWidget', () {
    testWidgets('plus and minus respect min and max', (tester) async {
      var value = 1;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => CountStepperWidget(
              value: value,
              max: 2,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(value, 2);

      // At max: plus is disabled.
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(value, 2);

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(value, 0);

      // At min: minus is disabled.
      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();
      expect(value, 0);
    });

    testWidgets(
      'direct entry submitted with Enter survives the dialog close animation',
      (tester) async {
        var value = 0;
        await tester.pumpWidget(
          wrap(
            StatefulBuilder(
              builder: (context, setState) => CountStepperWidget(
                value: value,
                onChanged: (v) => setState(() => value = v),
              ),
            ),
          ),
        );

        await tester.tap(find.text('0'));
        await tester.pumpAndSettle();
        expect(find.text('Enter value'), findsOneWidget);

        await tester.enterText(find.byType(TextField), '42');
        // Press Enter (IME done action), like a keyboard user would.
        await tester.testTextInput.receiveAction(TextInputAction.done);
        // Run the dialog exit animation to completion: with a controller
        // disposed too early this threw "used after dispose".
        await tester.pumpAndSettle();

        expect(value, 42);
        expect(find.text('Enter value'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('direct entry clamps to max', (tester) async {
      var value = 0;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => CountStepperWidget(
              value: value,
              max: 50,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('0'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '999');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(value, 50);
    });

    testWidgets('cancel keeps the current value', (tester) async {
      var value = 7;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => CountStepperWidget(
              value: value,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '99');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(value, 7);
    });
  });
}
