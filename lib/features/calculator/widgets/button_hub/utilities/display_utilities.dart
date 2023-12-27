import 'package:flutter/material.dart';

import '../../../../../common/models/display/display_controller.dart';

/// class specialized in controlling courses and updating the display's
/// TextEditingController
class DisplayUtilities {
  DisplayUtilities._();

  static void moveCursorLeft(
    TextEditingController controller,
  ) {
    String text = controller.text;
    int startSelection = controller.selection.start;

    RegExp regExp = RegExp(r',y|±dx|,𝚹|\(x|\(r');
    RegExpMatch? match =
        regExp.allMatches(text.substring(0, startSelection)).lastOrNull;

    if (match != null) {
      int startSelection = match.start + 1;
      int offset = match.end - match.start - 1;
      updateDisplay(
        controller,
        text,
        TextSelection(
            baseOffset: startSelection, extentOffset: startSelection + offset),
      );
    } else {
      moveCursor(controller, startSelection - 1);
    }
  }

  static void moveCursorRight(
    TextEditingController controller,
  ) {
    String text = controller.text;
    int startSelection = controller.selection.start;
    int endSelection = controller.selection.end;

    RegExp regExp = RegExp(r'r,|x,|x±|y\)|dx\)|x\)|𝚹\)');
    RegExpMatch? match = regExp.firstMatch(text.substring(endSelection));

    if (match != null) {
      startSelection = endSelection + match.start;
      int offset = match.end - match.start - 1;

      updateDisplay(
        controller,
        text,
        TextSelection(
            baseOffset: startSelection, extentOffset: startSelection + offset),
      );
    } else {
      moveCursor(controller, endSelection + 1);
    }
  }

  static void updateDisplay(
    TextEditingController controller,
    String text,
    TextSelection newSelection,
  ) {
    controller.text = text;
    controller.selection = newSelection;
  }

  static void moveCursor(
    TextEditingController controller,
    int position,
  ) {
    if (position < 0 || position > controller.text.length) return;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: position));
  }

  static void moveHistoryUp(DisplayController display) {
    String showExpression = display.downSecondLine;
    if (showExpression.isEmpty) return;
    updateDisplay(
      display.controller,
      showExpression,
      TextSelection.fromPosition(
        TextPosition(offset: showExpression.length),
      ),
    );
  }

  static void modeHistoryDown(DisplayController display) {
    String showExpression = display.upSecondLine;
    if (showExpression.isEmpty) return;
    updateDisplay(
      display.controller,
      showExpression,
      TextSelection.fromPosition(
        TextPosition(offset: showExpression.length),
      ),
    );
  }
}
