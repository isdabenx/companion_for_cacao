import 'package:companion_for_cacao/features/home/presentation/screens/home_screen.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/action_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // The About section presents shipped capabilities as tiles (name + one-line
  // description) instead of the old emoji bullet wall.
  const shippedFeatures = <String>[
    'Guided setup',
    'Score calculator',
    'Tile catalogue',
    'Rules and manuals',
    'Full expansions',
    'Multi-language',
  ];

  const plannedFeatures = <String>[
    'Turn timer',
    'History and statistics',
    'Custom settings',
  ];

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/package_info'),
          (methodCall) async {
            if (methodCall.method == 'getAll') {
              return <String, dynamic>{
                'appName': 'Companion for Cacao',
                'packageName': 'com.example.companion_for_cacao',
                'version': '2.3.0',
                'buildNumber': '5',
                'buildSignature': '',
                'installerStore': 'test',
              };
            }

            return null;
          },
        );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/package_info'),
          (methodCall) async {
            if (methodCall.method == 'getAll') {
              return <String, dynamic>{
                'appName': 'Companion for Cacao',
                'packageName': 'com.example.companion_for_cacao',
                'version': '2.3.0',
                'buildNumber': '5',
                'buildSignature': '',
              };
            }

            return null;
          },
        );
  });

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/package_info'),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/package_info'),
          null,
        );
  });

  group('HomeScreen', () {
    Future<void> pumpHomeScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('renders the hero and the main action cards', (tester) async {
      await pumpHomeScreen(tester);

      // A destination with no actions of its own carries no app bar at all:
      // the navigation already names the section and marks it, so a band
      // repeating that would be the chrome saying it twice.
      expect(find.byType(AppBar), findsNothing);
      // The lockup above the logo is a quiet uppercase eyebrow.
      expect(find.text('COMPANION FOR'), findsOneWidget);
      // Nothing in progress, so the one card is the way to start.
      // "Game", not "Game Setup": the same entry is how you get back to a
      // game already in progress, so it cannot be named after starting one.
      expect(find.widgetWithText(ActionCardWidget, 'Game'), findsOneWidget);
      expect(
        find.widgetWithText(ActionCardWidget, 'Resume Game'),
        findsNothing,
      );

      // Every destination is a tab in the bar and an item on the rail, so a
      // card repeating one would be a second menu doing the first menu's job.
      expect(find.widgetWithText(ActionCardWidget, 'Tiles'), findsNothing);
      expect(find.widgetWithText(ActionCardWidget, 'Rules'), findsNothing);
      expect(find.widgetWithText(ActionCardWidget, 'Scores'), findsNothing);
    });

    testWidgets('tucks capabilities and the repo link into About', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      // Collapsed by default: the launchpad reads as a way in, not a spec.
      expect(find.text(shippedFeatures.first), findsNothing);
      expect(find.text('About the app'), findsOneWidget);

      await tester.ensureVisible(find.text('About the app'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About the app'));
      await tester.pumpAndSettle();

      // Identity strip and grouped blocks.
      expect(find.text('Companion for Cacao'), findsOneWidget);
      expect(find.text('Open source'), findsOneWidget);
      expect(find.text("WHAT'S INCLUDED"), findsOneWidget);
      expect(find.text('IN DEVELOPMENT'), findsOneWidget);

      for (final feature in shippedFeatures) {
        expect(find.text(feature), findsOneWidget);
      }
      for (final feature in plannedFeatures) {
        expect(find.text(feature), findsOneWidget);
      }
      // "soon" badge on every planned row.
      expect(find.text('SOON'), findsNWidgets(plannedFeatures.length));

      // The repository is a button, not a raw URL.
      expect(find.text('GitHub repository'), findsOneWidget);
      expect(
        find.text('https://github.com/isdabenx/companion_for_cacao'),
        findsNothing,
      );
    });
  });
}
