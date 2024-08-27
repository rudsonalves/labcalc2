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

class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle primaryButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.secondary;
    final onPrimary = colorScheme.onPrimary;

    return ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primary),
        foregroundColor: WidgetStateProperty.all(onPrimary));
  }
}
