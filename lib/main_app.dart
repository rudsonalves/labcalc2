import 'package:flutter/material.dart';

import 'common/singletons/app_settings.dart';
import 'common/themes/colors/color_schemes.g.dart';
import 'features/about/about_page.dart';
import 'features/calculator/calculator_page.dart';
import 'features/settings/settings_page.dart';
import 'features/splash/splash_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final appSettings = AppSettings.instance;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: appSettings.themeMode$,
        builder: (context, _) {
          return MaterialApp(
            themeMode: appSettings.themeMode,
            theme: ThemeData(
              fontFamily: 'RopaSans',
              useMaterial3: true,
              colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData(
              fontFamily: 'RopaSans',
              useMaterial3: true,
              colorScheme: darkColorScheme,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: SplashPage.routeName,
            routes: {
              CalculatorPage.routeName: (context) => const CalculatorPage(),
              SplashPage.routeName: (context) => const SplashPage(),
              AboutPage.routeName: (context) => const AboutPage(),
              SettingsPage.routeName: (context) => const SettingsPage(),
            },
          );
        });
  }
}
