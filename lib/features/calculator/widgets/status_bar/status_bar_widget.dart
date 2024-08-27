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

import 'package:flutter/material.dart';

import '../../../../common/constants/constants.dart';

class StatusBarWidget extends StatelessWidget {
  final int fix;
  final bool isRadians;
  final bool truncate;
  final TypeMean mean;
  final TypeDeviation deviation;
  final int counter;

  const StatusBarWidget({
    super.key,
    required this.fix,
    required this.isRadians,
    required this.truncate,
    required this.mean,
    required this.deviation,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          'Fix: ${fix == -1 ? 'off' : '$fix'}'
          '    ${isRadians ? 'rad' : 'deg'}'
          '    Trunc: ${truncate ? 'on' : 'off'}'
          '    Mean: ${meanSignature[mean]} ±'
          ' ${deviationSignature[deviation]}'
          ' (n = $counter})',
        ),
      ),
    );
  }
}
