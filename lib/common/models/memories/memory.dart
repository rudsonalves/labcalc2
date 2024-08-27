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

import '../measure/measure.dart';

/// This class implement a exception for memory unsupported type
class MemoryUnsupportedType implements Exception {
  String error() => 'ERROR: memory class unsupported type.';
}

class Memory {
  dynamic _value;

  dynamic get value => _value;

  set value(dynamic newValue) {
    if (newValue is num) {
      _value = newValue.toDouble();
    } else if (newValue is Measure) {
      _value = newValue;
    } else {
      throw MemoryUnsupportedType();
    }
  }

  Memory(newValue) {
    value = newValue;
  }

  bool get isDouble => _value is double;
  bool get isMeasure => _value is Measure;

  @override
  String toString() {
    return 'Memory: $_value';
  }
}
