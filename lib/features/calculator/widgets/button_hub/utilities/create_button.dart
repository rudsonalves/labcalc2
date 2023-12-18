import 'package:flutter/material.dart';
import 'package:labcalc2/common/singletons/app_settings.dart';

import '../../../../../common/models/key_model/key_model.dart';
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
          buttonCallBack: buttonCallBack,
        ),
      );
    }

    return buttons;
  }

  static List<Widget> memories(
    void Function(KeyModel) buttonCallBack,
  ) {
    final app = AppSettings.instance;
    int aMemory = 'A'.runes.first;
    int fMemory = 'E'.runes.first;

    List<Widget> buttons = [];

    for (int i = 0; i < 4; i++) {
      buttons.add(
        ListenableBuilder(
          listenable: app.secondFunc$,
          builder: (context, _) {
            return CalcButton(
              !app.secondFunc
                  ? String.fromCharCode(aMemory + i)
                  : String.fromCharCode(fMemory + i),
              fontColor:
                  !app.secondFunc ? AppColors.fontBlack : AppColors.fontYellow,
              buttonColor: AppColors.buttonMemories,
              buttonCallBack: buttonCallBack,
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
              buttonCallBack: (_) => moveKeyButtons(directionsMap[key]!),
            ))
        .toList();
  }
}
