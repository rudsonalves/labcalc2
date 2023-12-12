import 'package:flutter/material.dart';
import 'package:labcalc2/features/calculator/calculator_page.dart';

import 'features/splash/splash_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.routeName,
      routes: {
        CalculatorPage.routeName: (context) => const CalculatorPage(),
        SplashPage.routeName: (context) => const SplashPage(),
      },
    );
  }
}
