import 'package:companion_for_cacao/config/routes/app_router.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_fonts.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.greenDark,
      primary: AppColors.greenDark,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.greenNormal,
      onPrimaryContainer: AppColors.brown,
      secondary: AppColors.gold,
      onSecondary: AppColors.brown,
      secondaryContainer: AppColors.greenLight,
      onSecondaryContainer: AppColors.greenDarker,
      surface: AppColors.cream,
      onSurface: AppColors.brown,
      surfaceContainerHighest: AppColors.greenNormal,
    );

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: colorScheme,
        fontFamily: AppFonts.bodyFont,
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        appBarTheme: AppBarThemeData(
          backgroundColor: AppColors.greenNormal,
          foregroundColor: AppColors.brown,
          iconTheme: const IconThemeData(color: AppColors.iconColor),
          titleTextStyle: AppTextStyles.appBarTextStyle,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceCard,
          elevation: 3,
          shadowColor: AppColors.brown.withValues(alpha: 0.45),
          // Hairline warm border so cards stay crisp even on the cream panel.
          shape: AppShapes.shape(
            AppShapes.radiusL,
            side: BorderSide(
              color: AppColors.brown.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenDark,
            foregroundColor: AppColors.white,
            // Rounded rectangle, not the M3 stadium pill.
            shape: AppShapes.shape(AppShapes.radiusM),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.greenDark,
            foregroundColor: AppColors.white,
            shape: AppShapes.shape(AppShapes.radiusM),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.greenDarker,
            shape: AppShapes.shape(AppShapes.radiusM),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.greenDarker,
            side: const BorderSide(color: AppColors.greenDarker),
            shape: AppShapes.shape(AppShapes.radiusM),
          ),
        ),
        scaffoldBackgroundColor: AppColors.greenLight,
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.titleTextStyle,
          headlineMedium: AppTextStyles.markdownH2,
          headlineSmall: AppTextStyles.sectionTitle,
          titleLarge: AppTextStyles.boardgameTitle,
          titleMedium: AppTextStyles.sectionTitlePlain,
          titleSmall: AppTextStyles.sectionTitle,
          bodyLarge: AppTextStyles.markdownBody,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.menuItem,
          labelSmall: AppTextStyles.sectionSubtitle,
        ),
      ),
    );
  }
}
