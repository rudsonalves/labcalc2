import 'package:flutter/material.dart';

import 'settings_repository.dart';
import '../constants/constants.dart';
import '../models/app_settings_model.dart';

class AppSettings {
  AppSettings._();
  static final _instance = AppSettings._();
  static AppSettings get instance => _instance;

  static const int maxFix = 15;
  static const int minFix = -1;

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

  bool _testMode = false;

  String _version = '';

  String get version => _version;

  set version(String newVersion) {
    _version = newVersion;
    updateSettings();
  }

  // themeMode getter and setter
  ThemeMode get themeMode => themeMode$.value;
  set themeMode(ThemeMode mode) {
    themeMode$.value = mode;
    updateSettings();
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
    updateSettings();
  }

  // Getter and Setter to mean
  TypeMean get mean => mean$.value;
  set mean(TypeMean value) {
    mean$.value = value;
    updateSettings();
  }

  // Getter and setter to mean
  TypeDeviation get deviation => deviation$.value;
  set deviation(TypeDeviation value) {
    deviation$.value = value;
    updateSettings();
  }

  int get counter => counter$.value;
  void setCounter(int value) => counter$.value = value;

  bool get expressionError => expressionError$.value;
  void expressionErrorOn() => expressionError$.value = true;
  void expressionErrorOff() => expressionError$.value = false;

  int get fix => fix$.value;
  void incrementFix([bool save = true]) {
    if (fix < maxFix) {
      fix$.value++;
      if (save) updateSettings();
    }
  }

  void decrementFix([bool save = true]) {
    if (fix > minFix) {
      fix$.value--;
      if (save) updateSettings();
    }
  }

  set fix(int value) {
    if (value >= minFix && value <= maxFix) {
      fix$.value = value;
      updateSettings();
    }
  }

  bool get isRadians => isRadians$.value;
  void toggleIsRadians() {
    isRadians$.value = !isRadians$.value;
    updateSettings();
  }

  bool get truncate => truncate$.value;
  void toggleTruncate() {
    truncate$.value = !truncate$.value;
    updateSettings();
  }

  bool get secondFunc => secondFunc$.value;
  void toggleSecondFunc() => secondFunc$.value = !secondFunc$.value;

  void updateSettings() {
    if (!_isLoading && !_testMode) {
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
  }

  reset([bool testMode = false]) {
    if (testMode) _testMode = testMode;
    themeMode = ThemeMode.dark;
    mean = TypeMean.arithmetic;
    deviation = TypeDeviation.meanDeviation;
    fix = -1;
    isRadians$.value = true;
    truncate$.value = false;
    secondFunc$.value = false;
  }

  void loadSettings() {
    final AppSettingsModel settings = _repository.settings;
    _isLoading = true;

    _stringToThemeMode(settings.themeMode);
    _intToMean(settings.mean);
    _intToDeviation(settings.deviation);
    fix$.value = settings.fix;
    _version = settings.version;
    isRadians$.value = settings.isRadian;
    truncate$.value = settings.truncate;

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
      version: _version,
      isRadian: isRadians,
      truncate: truncate,
    );
  }
}
