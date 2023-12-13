import 'package:flutter/foundation.dart';

import 'splash_page_state.dart';

class SplashPageController extends ChangeNotifier {
  SplashPageState _state = SplashPageStateInitial();

  SplashPageState get state => _state;

  void _changeState(SplashPageState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> animation() async {
    _changeState(SplashPageStateLoading());
    await Future.delayed(const Duration(seconds: 1));
    _changeState(SplashPageStateSuccess());
  }
}
