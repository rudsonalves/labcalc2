import 'package:flutter/material.dart';
import 'package:labcalc2/features/calculator/calculator_page.dart';
import 'package:labcalc2/features/splash/splash_page_controller.dart';
import 'package:labcalc2/features/splash/splash_page_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _splashController = SplashPageController();

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) { })
    _splashController.animation();
    _splashController.addListener(() {
      if (_splashController.state is SplashPageStateSuccess) {
        Navigator.pushReplacementNamed(context, CalculatorPage.routeName);
      }
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Page...'),
      ),
    );
  }
}
