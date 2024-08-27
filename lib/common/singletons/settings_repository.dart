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

import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/app_settings_model.dart';

class SettingsReposiroty {
  SettingsReposiroty._();
  static final _instance = SettingsReposiroty._();
  static SettingsReposiroty get instance => _instance;

  final AppSettingsModel _settings = AppSettingsModel();
  AppSettingsModel get settings => _settings;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveSettings(AppSettingsModel app) async {
    try {
      app.toMap().forEach((key, value) async {
        await _storage.write(key: key, value: value.toString());
      });
    } catch (err) {
      log('SettingsReposiroty.saveSettings: $err');
    }
  }

  Future<void> loadSettings() async {
    try {
      Map<String, String> allValues = await _storage.readAll();

      final newSettings = AppSettingsModel.fromMap(allValues);

      _settings.themeMode = newSettings.themeMode;
      _settings.mean = newSettings.mean;
      _settings.deviation = newSettings.deviation;
      _settings.fix = newSettings.fix;
      _settings.version = newSettings.version;
      _settings.isRadian = newSettings.isRadian;
      _settings.truncate = newSettings.truncate;
    } catch (err) {
      log('SettingsReposiroty.loadSettings: $err');
    }
  }

  @override
  String toString() {
    return 'Settings: theme: ${settings.themeMode},'
        ' mean: ${settings.mean}, deviation: ${settings.deviation},'
        ' fix: ${settings.fix}';
  }
}
