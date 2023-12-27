import 'package:flutter/material.dart';
import 'package:labcalc2/common/themes/styles/app_text_styles.dart';

import '../calculator/calculator_page.dart';
import 'splash_page_controller.dart';
import 'splash_page_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _splashController = SplashPageController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _splashController.animation();
    _splashController.addListener(() {
      if (_splashController.state is SplashPageStateSuccess) {
        Navigator.pushReplacementNamed(context, CalculatorPage.routeName);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/labCalc.png',
                scale: 3,
              ),
              const SizedBox(height: 24),
              const Text(
                'LabCalc2',
                style: AppTextStyle.textStyleBig,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
