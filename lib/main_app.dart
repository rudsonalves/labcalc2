// Copyright (C) 2024 Rudson Alves
// 
// This file is part of labcalc2.
// 
// labcalc2 is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// labcalc2 is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with labcalc2.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import 'common/singletons/app_settings.dart';
import 'common/themes/colors/app_colors.dart';
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
            fontFamily: 'Roboto',
            useMaterial3: true,
            colorScheme: lightColorScheme,
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: AppColors.fontBlue, // Selection text color
              selectionHandleColor:
                  AppColors.fontYellow, // Color of text selection handles
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: 'Roboto',
            useMaterial3: true,
            colorScheme: darkColorScheme,
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: AppColors.fontBlue, // Selection text color
              selectionHandleColor:
                  AppColors.fontYellow, // Color of text selection handles
            ),
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
      },
    );
  }
}
