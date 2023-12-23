import 'package:flutter/material.dart';

import '../../database/settings_repository.dart';
import '../constants/constants.dart';
import '../models/app_settings_model.dart';

class AppSettings {
  AppSettings._();
  static final _instance = AppSettings._();
  static AppSettings get instance => _instance;

  final themeMode$ = ValueNotifier<ThemeMode>(ThemeMode.dark);
  final mean$ = ValueNotifier<TypeMean>(TypeMean.arithmetic);
  final deviation$ = ValueNotifier<TypeDeviation>(TypeDeviation.meanDeviation);
  final fix$ = ValueNotifier<int>(-1);
  final isRadians$ = ValueNotifier<bool>(true);
  final truncate$ = ValueNotifier<bool>(false);
  final secondFunc$ = ValueNotifier<bool>(false);
  final expressionError$ = ValueNotifier<bool>(false);
  final counter$ = ValueNotifier<int>(0);

  final _repository = SettingsReposiroty.instance;
  bool _isLoading = false;

  // Initialize aplication settings
  void updateAppSettings() {
    loadRealmSettings();
  }

  // themeMode getter and setter
  ThemeMode get themeMode => themeMode$.value;
  set themeMode(ThemeMode mode) {
    themeMode$.value = mode;
    _updateSettings();
  }

  // themeMode toggle ThemeMode
  void toggleThemeMode() {
    if (themeMode == ThemeMode.dark) {
      themeMode$.value = ThemeMode.light;
    } else if (themeMode == ThemeMode.light) {
      themeMode$.value = ThemeMode.system;
    } else {
      themeMode$.value = ThemeMode.dark;
    }
    _updateSettings();
  }

  // Getter and Setter to mean
  TypeMean get mean => mean$.value;
  set mean(TypeMean value) {
    mean$.value = value;
    _updateSettings();
  }

  // Getter and setter to mean
  TypeDeviation get deviation => deviation$.value;
  set deviation(TypeDeviation value) {
    deviation$.value = value;
    _updateSettings();
  }

  int get counter => counter$.value;
  void setCounter(int value) => counter$.value = value;

  bool get expressionError => expressionError$.value;
  void expressionErrorOn() => expressionError$.value = true;
  void expressionErrorOff() => expressionError$.value = false;

  int get fix => fix$.value;
  void incrementFix() {
    if (fix > 7) return;
    fix$.value++;
    _updateSettings();
  }

  void decrementFix() {
    if (fix < 0) return;
    fix$.value--;
    _updateSettings();
  }

  set fix(int value) {
    if (value >= -1 && value < 12) {
      fix$.value = value;
      _updateSettings();
    }
  }

  bool get isRadians => isRadians$.value;
  void toggleIsRadians() => isRadians$.value = !isRadians$.value;

  bool get truncate => truncate$.value;
  void toggleTruncate() => truncate$.value = !truncate$.value;

  bool get secondFunc => secondFunc$.value;
  void toggleSecondFunc() => secondFunc$.value = !secondFunc$.value;

  void _updateSettings() {
    if (!_isLoading) {
      _repository.saveSettings(toSettingsModel());
    }
  }

  void dispose() {
    themeMode$.dispose();
    mean$.dispose();
    deviation$.dispose();
    fix$.dispose();
    isRadians$.dispose();
    truncate$.dispose();
    secondFunc$.dispose();
    expressionError$.dispose();
    counter$.dispose();
    _repository.dispose();
  }

  reset() {
    themeMode = ThemeMode.dark;
    mean = TypeMean.arithmetic;
    deviation = TypeDeviation.meanDeviation;
    fix = -1;
    isRadians$.value = true;
    truncate$.value = false;
    secondFunc$.value = false;
    _updateSettings();
  }

  void loadRealmSettings() {
    final AppSettingsModel settings = _repository.settings;
    _isLoading = true;

    _stringToThemeMode(settings.themeMode);
    _intToMean(settings.mean);
    _intToDeviation(settings.deviation);
    fix$.value = settings.fix;

    _isLoading = false;
  }

  //
  String _themeModeToString() => themeMode.toString().split('.')[1];
  void _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }
  }

  //
  int _meanToInt() => mean.index;
  void _intToMean(int value) => mean = TypeMean.values[value];

  //
  int _deviationToInt() => deviation.index;
  void _intToDeviation(int value) => deviation = TypeDeviation.values[value];

  //
  AppSettingsModel toSettingsModel() {
    return AppSettingsModel(
      themeMode: _themeModeToString(),
      mean: _meanToInt(),
      deviation: _deviationToInt(),
      fix: fix,
    );
  }
}
