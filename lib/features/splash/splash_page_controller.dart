import 'package:flutter/foundation.dart';

import '../../common/singletons/settings_repository.dart';
import 'splash_page_state.dart';

class SplashPageController extends ChangeNotifier {
  SplashPageState _state = SplashPageStateInitial();

  SplashPageState get state => _state;

  final _repository = SettingsReposiroty.instance;

  void _changeState(SplashPageState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> animation() async {
    _changeState(SplashPageStateLoading());
    _repository.init();
    _repository.loadSettings();
    await Future.delayed(const Duration(milliseconds: 1500));
    _changeState(SplashPageStateSuccess());
  }
}
