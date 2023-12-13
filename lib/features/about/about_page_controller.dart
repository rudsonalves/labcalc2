import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'about_page_state.dart';

class AboutPageController extends ChangeNotifier {
  late final PackageInfo _packageInfo;

  PackageInfo get packageInfo => _packageInfo;

  AboutPageState _state = AboutPageStateInitial();

  AboutPageState get state => _state;

  void _changeState(AboutPageState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> init() async {
    _changeState(AboutPageStateLoading());

    _packageInfo = await PackageInfo.fromPlatform();

    _changeState(AboutPageStateSuccess());
  }
}
