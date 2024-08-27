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

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppSettingsModel {
  String themeMode;
  int mean;
  int deviation;
  int fix;
  String version;
  bool isRadian;
  bool truncate;

  AppSettingsModel({
    this.themeMode = 'dark',
    this.mean = 0,
    this.deviation = 0,
    this.fix = -1,
    this.version = '',
    this.isRadian = true,
    this.truncate = false,
  });

  @override
  String toString() {
    return 'AppSettingsModel(themeMode: $themeMode, mean:'
        ' $mean, deviation: $deviation, fix: $fix)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeMode': themeMode,
      'mean': mean,
      'deviation': deviation,
      'fix': fix,
      'version': version,
      'isRadian': isRadian,
      'truncate': truncate,
    };
  }

  factory AppSettingsModel.fromMap(Map<String, String> map) {
    return AppSettingsModel(
      themeMode: map['themeMode']!,
      mean: int.tryParse(map['mean']!) ?? 0,
      deviation: int.tryParse(map['deviation']!) ?? 0,
      fix: int.tryParse(map['fix']!) ?? -1,
      version: map['version']!,
      isRadian: bool.tryParse(map['isRadian']!) ?? true,
      truncate: bool.tryParse(map['truncate']!) ?? false,
    );
  }
}
