import 'package:companion_for_cacao/config/routes/app_router.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_fonts.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
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
      surface: AppColors.greenLight,
      onSurface: AppColors.brown,
      surfaceContainerHighest: AppColors.greenNormal,
    );

    return MaterialApp.router(
      routerConfig: router,
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
          color: colorScheme.primaryContainer,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenDark,
            foregroundColor: AppColors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.greenDarker),
        ),
        scaffoldBackgroundColor: AppColors.greenLight,
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.titleTextStyle,
          headlineMedium: AppTextStyles.markdownH2,
          titleLarge: AppTextStyles.boardgameTitleTextStyle,
          titleMedium: AppTextStyles.labelStep,
          bodyLarge: AppTextStyles.markdownBody,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.menu,
        ),
      ),
    );
  }
}
