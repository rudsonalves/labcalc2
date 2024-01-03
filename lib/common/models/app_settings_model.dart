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
