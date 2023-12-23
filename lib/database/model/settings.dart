import 'package:realm/realm.dart';

part 'settings.g.dart';

@RealmModel()
class _Settings {
  @PrimaryKey()
  late int id = 1;

  late String themeMode;
  late int mean;
  late int deviation;
  late int fix;
}
