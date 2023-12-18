import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppSettings {
  AppSettings._();
  static final _instance = AppSettings._();
  static AppSettings get instance => _instance;

  reset() {
    themeMode$.value = ThemeMode.dark;
    mean$.value = TypeMean.arithmetic;
    deviation$.value = TypeDeviation.meanDeviation;
    fix$.value = -1;
    isRadians$.value = true;
    truncate$.value = false;
    secondFunc$.value = false;
  }

  final themeMode$ = ValueNotifier<ThemeMode>(ThemeMode.dark);
  final mean$ = ValueNotifier<TypeMean>(TypeMean.arithmetic);
  final deviation$ = ValueNotifier<TypeDeviation>(TypeDeviation.meanDeviation);
  final fix$ = ValueNotifier<int>(-1);
  final isRadians$ = ValueNotifier<bool>(true);
  final truncate$ = ValueNotifier<bool>(false);
  final secondFunc$ = ValueNotifier<bool>(false);

  ThemeMode get themeMode => themeMode$.value;
  void toggleThemeMode() {
    if (themeMode == ThemeMode.dark) {
      themeMode$.value = ThemeMode.light;
    } else if (themeMode == ThemeMode.light) {
      themeMode$.value = ThemeMode.system;
    } else {
      themeMode$.value = ThemeMode.dark;
    }
  }

  TypeMean get mean => mean$.value;
  set mean(TypeMean value) => mean$.value = value;

  TypeDeviation get deviation => deviation$.value;
  set deviation(TypeDeviation value) => deviation$.value = value;

  int get fix => fix$.value;
  void incrementFix() {
    if (fix > 7) return;
    fix$.value++;
  }

  void decrementFix() {
    if (fix < 0) return;
    fix$.value--;
  }

  bool get isRadians => isRadians$.value;
  bool get truncate => truncate$.value;
  void toggleIsRadians() => isRadians$.value = !isRadians$.value;
  void toggleTruncate() => truncate$.value = !truncate$.value;

  bool get secondFunc => secondFunc$.value;
  void toggleSecondFunc() => secondFunc$.value = !secondFunc$.value;
}
