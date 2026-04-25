import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/features/rule/presentation/rule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('RuleScreen', () {
    GoRouter createRouter() {
      return GoRouter(
        initialLocation: AppRoutes.rules,
        routes: [
          GoRoute(
            path: AppRoutes.rules,
            builder: (context, state) => const RuleScreen(),
          ),
          GoRoute(
            path: AppRoutes.rulePdf,
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      );
    }

    Future<void> pumpRuleScreen(WidgetTester tester) async {
      final router = createRouter();
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump();
    }

    testWidgets('renders title, section headers, and rule card titles', (
      tester,
    ) async {
      await pumpRuleScreen(tester);

      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('Rules')),
        findsOneWidget,
      );
      expect(find.text('BASE GAME'), findsOneWidget);
      expect(find.text('EXPANSION: CHOCOLATL'), findsOneWidget);
      expect(find.text('EXPANSION: DIAMANTE'), findsOneWidget);
      expect(find.text('Instructions'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Chocolatl Rules'), findsOneWidget);
      expect(find.text('Diamante Rules'), findsOneWidget);
    });

    testWidgets('shows a PDF icon on each rule card', (tester) async {
      await pumpRuleScreen(tester);

      expect(find.byIcon(Icons.picture_as_pdf), findsNWidgets(4));
    });
  });
}
