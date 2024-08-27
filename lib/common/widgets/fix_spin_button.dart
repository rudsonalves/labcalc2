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

import 'dart:async';

import 'package:flutter/material.dart';

import '../singletons/app_settings.dart';
import '../themes/styles/app_text_styles.dart';

class FixSpinButton extends StatefulWidget {
  const FixSpinButton({super.key});

  @override
  State<FixSpinButton> createState() => _FixSpinButtonState();
}

class _FixSpinButtonState extends State<FixSpinButton> {
  final AppSettings _app = AppSettings.instance;

  late int value;
  Timer? _incrementTimer;
  Timer? _decrementTimer;
  bool _isLongPressActive = false;

  static const int sleetTime = 200;
  static const int maxValue = 15;
  static const int minValue = -1;

  @override
  void initState() {
    super.initState();
    value = _app.fix;
  }

  String get textValue => value == minValue ? 'off' : value.toString();

  void _increment([bool save = false]) {
    if (value < maxValue) {
      value++;
      _app.incrementFix(save);
    }
  }

  void _decrement([bool save = false]) {
    if (value > minValue) {
      value--;
      _app.decrementFix(save);
    }
  }

  void _longIncrement() {
    _incrementTimer = Timer.periodic(
      const Duration(milliseconds: sleetTime),
      (timer) {
        if (value < maxValue) {
          _increment();
        } else {
          _incrementTimer?.cancel();
        }
      },
    );
  }

  void _longDecrement() {
    _decrementTimer = Timer.periodic(
      const Duration(milliseconds: sleetTime),
      (timer) {
        if (value > minValue) {
          _decrement();
        } else {
          _decrementTimer?.cancel();
        }
      },
    );
  }

  void _stopIncrement() {
    _incrementTimer?.cancel();
    _app.updateSettings();
  }

  void _stropDecrement() {
    _decrementTimer?.cancel();
    _app.updateSettings();
  }

  void _onLongPressIncrement() {
    _isLongPressActive = true;
    _longIncrement();
  }

  void _onLongPressDecrement() {
    _isLongPressActive = true;
    _longDecrement();
  }

  void _onLongPressEndIncrement(LongPressEndDetails details) {
    _isLongPressActive = false;
    _stopIncrement();
  }

  void _onLongPressEndDecrement(LongPressEndDetails details) {
    _isLongPressActive = false;
    _stropDecrement();
  }

  void _onTapIncrement() {
    if (!_isLongPressActive) {
      _increment(true);
    }
  }

  void _onTapDecrement() {
    if (!_isLongPressActive) {
      _decrement(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Fix value:',
          style: AppTextStyle.textStyleNormal,
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: Ink(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onLongPress: _onLongPressDecrement,
              onLongPressEnd: _onLongPressEndDecrement,
              child: InkWell(
                onTap: _onTapDecrement,
                customBorder: const CircleBorder(),
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 56,
          child: Center(
            child: ListenableBuilder(
              listenable: _app.fix$,
              builder: (context, _) {
                return Text(
                  textValue,
                  style: AppTextStyle.textStyleMedium,
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: Ink(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onLongPress: _onLongPressIncrement,
              onLongPressEnd: _onLongPressEndIncrement,
              child: InkWell(
                onTap: _onTapIncrement,
                customBorder: const CircleBorder(),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
