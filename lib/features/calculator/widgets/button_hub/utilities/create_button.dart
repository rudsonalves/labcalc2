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

import '../../../../../common/models/key_model/key_model.dart';
import '../../../../../common/singletons/app_settings.dart';
import '../../../../../common/themes/colors/app_colors.dart';
import '../button_hub.dart';
import '../calc_button.dart';

const Map<String, DirectionKeys> directionsMap = {
  '◀': DirectionKeys.left,
  '▲': DirectionKeys.top,
  '▼': DirectionKeys.bottom,
  '▶': DirectionKeys.right,
};

/// class specialized in creating buttons
class CreateButton {
  CreateButton._();

  static List<Widget> numbers(
    String numbers,
    void Function(KeyModel) buttonCallBack,
  ) {
    List<Widget> buttons = [];
    for (String number in numbers.split('')) {
      buttons.add(
        CalcButton(
          number,
          buttonColor: AppColors.buttonBasics,
          onPress: buttonCallBack,
        ),
      );
    }

    return buttons;
  }

  static List<Widget> memories(
    void Function(KeyModel) buttonCallBack,
  ) {
    final app = AppSettings.instance;
    // final memories = AppMemories.instante;

    int aMemory = 'A'.runes.first;
    int eMemory = 'E'.runes.first;

    List<Widget> buttons = [];

    for (int i = 0; i < 4; i++) {
      // String label = !app.secondFunc
      //     ? String.fromCharCode(aMemory + i)
      //     : String.fromCharCode(eMemory + i);
      buttons.add(
        ListenableBuilder(
          listenable: app.secondFunc$,
          builder: (context, _) {
            return CalcButton(
              !app.secondFunc
                  ? String.fromCharCode(aMemory + i)
                  : String.fromCharCode(eMemory + i),
              tooltip: '', // memories.memories[label]!.value.toString(),
              fontColor:
                  !app.secondFunc ? AppColors.fontWhite : AppColors.fontYellow,
              buttonColor: AppColors.buttonMemories,
              onPress: buttonCallBack,
            );
          },
        ),
      );
    }

    return buttons;
  }

  static List<Widget> directionals(
      void Function(DirectionKeys) moveKeyButtons) {
    Map<String, DirectionKeys> directionsMap = {
      '◀': DirectionKeys.left,
      '▲': DirectionKeys.top,
      '▼': DirectionKeys.bottom,
      '▶': DirectionKeys.right,
    };

    return directionsMap.keys
        .map((key) => CalcButton(
              key,
              buttonColor: AppColors.buttonDirectional,
              fontColor: AppColors.fontBlack,
              onPress: (_) => moveKeyButtons(directionsMap[key]!),
            ))
        .toList();
  }
}
