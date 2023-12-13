import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppSettings {
  AppSettings._();
  static final _instance = AppSettings._();
  static AppSettings get instance => _instance;

  ValueNotifier<ThemeMode> themeMode$ = ValueNotifier(ThemeMode.dark);
  ValueNotifier<TypeMean> mean$ = ValueNotifier(TypeMean.arithmetic);
  ValueNotifier<TypeDeviation> deviation$ =
      ValueNotifier(TypeDeviation.meanDeviation);
  ValueNotifier<int> fix$ = ValueNotifier(-1);
  ValueNotifier<bool> isRadians$ = ValueNotifier(true);
  ValueNotifier<bool> truncate$ = ValueNotifier(false);

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
}
