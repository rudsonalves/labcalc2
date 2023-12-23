import 'package:realm/realm.dart';

import 'model/settings.dart';
import '../common/models/app_settings_model.dart';

class SettingsReposiroty {
  SettingsReposiroty._();
  static final _instance = SettingsReposiroty._();
  static SettingsReposiroty get instance => _instance;

  final AppSettingsModel _settings = AppSettingsModel();
  AppSettingsModel get settings => _settings;

  late final Realm realm;

  void init() {
    _openRealm();
  }

  void dispose() {
    realm.close();
  }

  void _openRealm() {
    LocalConfiguration config = Configuration.local([Settings.schema]);
    realm = Realm(config);
  }

  void saveSettings(AppSettingsModel app) {
    if (realm.isClosed) _openRealm();

    Settings? settings = realm.find<Settings>(1);
    if (settings == null) {
      Settings settings = Settings(
        1,
        app.themeMode,
        app.mean,
        app.deviation,
        app.fix,
      );

      realm.write(() => realm.add(settings));
    } else {
      realm.write(() {
        settings.themeMode = app.themeMode;
        settings.mean = app.mean;
        settings.deviation = app.deviation;
        settings.fix = app.fix;
      });
    }
  }

  void loadSettings() {
    if (realm.isClosed) _openRealm();

    Settings? settings = realm.find(1);
    if (settings != null) {
      _settings.themeMode = settings.themeMode;
      _settings.mean = settings.mean;
      _settings.deviation = settings.deviation;
      _settings.fix = settings.fix;
    }
  }

  @override
  String toString() {
    return 'Settings: theme: ${settings.themeMode},'
        ' mean: ${settings.mean}, deviation: ${settings.deviation},'
        ' fix: ${settings.fix}';
  }
}
