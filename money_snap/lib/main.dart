import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'core/di/injection.dart';
import 'core/locale/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_controller.dart';
import 'i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.init();
  await Injection.init();
  await ThemeController.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          final lightColorScheme = ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          );
          final darkColorScheme = ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          );

          return ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.themeMode,
            builder: (context, themeMode, _) {
              return MaterialApp.router(
                title: context.t.appTitle,
                themeMode: themeMode,
                theme: ThemeData(
                  colorScheme: lightColorScheme,
                  useMaterial3: true,
                  textTheme: GoogleFonts.openSansTextTheme(),
                ),
                darkTheme: ThemeData(
                  colorScheme: darkColorScheme,
                  useMaterial3: true,
                  textTheme: GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme),
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
      ),
    );
  }
}
