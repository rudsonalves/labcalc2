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

import '../measure/measure_functions.dart';

const Map<String, CallFunction> functionMap = {
  'ln': CallFunction('ln', ln),
  'abs': CallFunction('abs', abs),
  'log': CallFunction('log', log),
  'exp': CallFunction('exp', exp),
  'sin': CallFunction('sin', sin),
  'cos': CallFunction('cos', cos),
  'tan': CallFunction('tan', tan),
  'asin': CallFunction('asin', asin),
  'acos': CallFunction('acos', acos),
  'atan': CallFunction('atan', atan),
  'pow10': CallFunction('pow10', pow10),
  'pow3': CallFunction('pow3', pow3),
  'powy': CallFunction('powy', pow, 2),
  'pow': CallFunction('pow', pow),
  'sqr3': CallFunction('sqr3', sqr3),
  'sqry': CallFunction('sqry', sqry, 2),
  'sqr': CallFunction('sqr', sqr),
  'pol': CallFunction('pol', pol, 2),
  'rec': CallFunction('rec', rec, 2),
};

class CallFunction {
  final String label;
  final Function function;
  final int numberOfParameters;

  const CallFunction(
    this.label,
    this.function, [
    this.numberOfParameters = 1,
  ]);

  double evaluate(double x, [double y = 0]) {
    if (numberOfParameters == 1) {
      return function(x);
    } else {
      return function(x, y);
    }
  }

  @override
  String toString() {
    return (numberOfParameters == 1) ? '$label(x)' : '$label(x,y)';
  }
}
