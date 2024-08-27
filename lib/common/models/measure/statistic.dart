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

import '../../singletons/app_settings.dart';
import 'measure.dart';
import 'measure_functions.dart';

class StatisticController {
  StatisticController._();
  static final _instance = StatisticController._();
  static StatisticController get instance => _instance;

  final _app = AppSettings.instance;

  final List<double> _values = [];
  List<double> get values => _values;

  Measure _mean = Measure();

  void add(double value) {
    _values.add(value);
    _app.setCounter(length);
  }

  void removeLast() {
    _values.removeLast();
    _app.setCounter(length);
  }

  void clear() {
    _values.clear();
    _app.setCounter(0);
  }

  bool get isEmpty => _values.isEmpty;
  bool get isNotEmpty => _values.isNotEmpty;

  int get length => _values.length;

  Measure get mean => _calculate();

  Measure _calculate() {
    _mean = calculateXm(_values);
    return _mean;
  }
}
