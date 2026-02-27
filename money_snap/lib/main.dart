import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'core/currency/currency_controller.dart';
import 'core/di/injection.dart';
import 'core/locale/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_controller.dart';
import 'i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.init();
  await CurrencyController.instance.init();
  await Injection.init();
  await ThemeController.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final _lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    surface: AppColors.surface,
  );

  static final _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.darkPrimary.withOpacity(0.2),
    onPrimaryContainer: AppColors.darkTextPrimary,
    secondary: AppColors.darkPrimary,
    onSecondary: Colors.white,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerHighest: AppColors.darkSurfaceElevated,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkDivider,
    outlineVariant: AppColors.darkDivider.withOpacity(0.5),
    error: AppColors.darkExpense,
    onError: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          return ValueListenableBuilder<AppCurrency>(
            valueListenable: CurrencyController.instance.currency,
            builder: (context, _, __) {
              return ValueListenableBuilder<ThemeMode>(
                valueListenable: ThemeController.instance.themeMode,
                builder: (context, themeMode, _) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: context.t.appTitle,
                themeMode: themeMode,
                theme: ThemeData(
                  colorScheme: _lightColorScheme,
                  useMaterial3: true,
                  scaffoldBackgroundColor: AppColors.background,
                  textTheme: GoogleFonts.interTextTheme().copyWith(
                    titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400),
                    bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400),
                  ),
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    centerTitle: false,
                    backgroundColor: Colors.transparent,
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    elevation: 3,
                    highlightElevation: 6,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  cardTheme: CardThemeData(
                    elevation: 0,
                    color: AppColors.surface,
                    shadowColor: AppColors.overlayLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                darkTheme: ThemeData(
                  colorScheme: _darkColorScheme,
                  useMaterial3: true,
                  scaffoldBackgroundColor: AppColors.darkBackground,
                  textTheme: GoogleFonts.interTextTheme(
                    ThemeData.dark().textTheme.apply(
                      bodyColor: AppColors.darkTextPrimary,
                      displayColor: AppColors.darkTextPrimary,
                    ),
                  ),
                  appBarTheme: AppBarTheme(
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    centerTitle: false,
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.darkTextPrimary,
                    titleTextStyle: GoogleFonts.inter(
                      color: AppColors.darkTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    elevation: 4,
                    highlightElevation: 8,
                    backgroundColor: AppColors.darkPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  cardTheme: CardThemeData(
                    elevation: 0,
                    color: AppColors.darkSurface,
                    shadowColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  dividerColor: AppColors.darkDivider,
                ),
                routerConfig: appRouter,
                locale: TranslationProvider.of(context).flutterLocale,
                supportedLocales: AppLocaleUtils.supportedLocales,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
              );
                },
              );
            },
          );
        },
      ),
    );
  }
}
