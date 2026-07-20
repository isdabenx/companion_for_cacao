import 'package:companion_for_cacao/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const completedFeatures = <String>[
    '🏠 Main Menu: Quick access to all functionalities.',
    '🗂 Tile Database: Comprehensive catalog of tiles.',
    '🔍 Tile Filtering: Search and filter by multiple criteria.',
    '🌴 Cacao Base Game: Full support and game setup.',
    '🍫 Chocolatl Expansion: Full support including all 4 modules.',
    '🚀 Diamante Expansion: Full support including all 4 modules.',
    '🎲 Game Dashboard: Summary, preparation, and tiles in play.',
    '🌟 Big Game Variant: Integration of all modules and expansions.',
    '📖 Integrated Manuals: Read the game rules.',
    '🏆 Score Calculator: Automatic final scoring with official tie rules.',
    '📊 Adaptive UI: Optimized design for different screen sizes.',
    '🔄 Auto-Updater: Automatic detection of new versions.',
  ];

  const pendingFeatures = <String>[
    '🕒 Turn Timer: Control the duration of each turn.',
    '📜 Game History: Record of finished games and player stats.',
    '⚙️ Custom Settings: Adjust the game experience.',
    '🌐 Multi-language Support: Interface in multiple languages.',
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
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('renders title, sections, and contact information', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('Home')),
        findsOneWidget,
      );
      expect(find.text('Companion for'), findsOneWidget);
      expect(find.text('Completed Features'), findsOneWidget);
      expect(find.text('Pending Features'), findsOneWidget);
      expect(find.text('Contact Me'), findsOneWidget);
      expect(find.text('Visit our GitHub repository:'), findsOneWidget);
      expect(
        find.text('https://github.com/isdabenx/companion_for_cacao'),
        findsOneWidget,
      );
    });

    testWidgets('shows all completed and pending feature items', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      for (final feature in completedFeatures) {
        expect(find.text(feature), findsOneWidget);
      }

      for (final feature in pendingFeatures) {
        expect(find.text(feature), findsOneWidget);
      }
    });
  });
}
