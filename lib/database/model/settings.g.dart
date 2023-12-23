// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Settings extends _Settings
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Settings(
    int id,
    String themeMode,
    int mean,
    int deviation,
    int fix,
  ) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Settings>({
        'id': 1,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'themeMode', themeMode);
    RealmObjectBase.set(this, 'mean', mean);
    RealmObjectBase.set(this, 'deviation', deviation);
    RealmObjectBase.set(this, 'fix', fix);
  }

  Settings._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get themeMode =>
      RealmObjectBase.get<String>(this, 'themeMode') as String;
  @override
  set themeMode(String value) => RealmObjectBase.set(this, 'themeMode', value);

  @override
  int get mean => RealmObjectBase.get<int>(this, 'mean') as int;
  @override
  set mean(int value) => RealmObjectBase.set(this, 'mean', value);

  @override
  int get deviation => RealmObjectBase.get<int>(this, 'deviation') as int;
  @override
  set deviation(int value) => RealmObjectBase.set(this, 'deviation', value);

  @override
  int get fix => RealmObjectBase.get<int>(this, 'fix') as int;
  @override
  set fix(int value) => RealmObjectBase.set(this, 'fix', value);

  @override
  Stream<RealmObjectChanges<Settings>> get changes =>
      RealmObjectBase.getChanges<Settings>(this);

  @override
  Settings freeze() => RealmObjectBase.freezeObject<Settings>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Settings._);
    return const SchemaObject(ObjectType.realmObject, Settings, 'Settings', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('themeMode', RealmPropertyType.string),
      SchemaProperty('mean', RealmPropertyType.int),
      SchemaProperty('deviation', RealmPropertyType.int),
      SchemaProperty('fix', RealmPropertyType.int),
    ]);
  }
}
