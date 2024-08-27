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
