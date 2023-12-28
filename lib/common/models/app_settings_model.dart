// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppSettingsModel {
  String themeMode;
  int mean;
  int deviation;
  int fix;
  String version;

  AppSettingsModel({
    this.themeMode = 'dark',
    this.mean = 0,
    this.deviation = 0,
    this.fix = -1,
    this.version = '',
  });

  @override
  String toString() {
    return 'AppSettingsModel(themeMode: $themeMode, mean:'
        ' $mean, deviation: $deviation, fix: $fix)';
  }
}
