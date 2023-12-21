import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../common/constants/buttons_label.dart';
import '../../../../common/models/display/display_controller.dart';
import '../../../../common/models/key_model/key_model.dart';
import '../../../../common/models/math_expression/math_expression.dart';
import '../../../../common/models/memories/app_memories.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/themes/styles/app_button_styles.dart';
import '../../../../common/widgets/fix_spin_button.dart';
import 'calc_button.dart';
import 'reset_button.dart';
import 'utilities/create_button.dart';
import 'utilities/display_control.dart';
import 'utilities/string_edit.dart';

enum DirectionKeys {
  left,
  top,
  bottom,
  right,
}

class ButtonHub extends StatefulWidget {
  const ButtonHub({super.key});

  @override
  State<ButtonHub> createState() => _ButtonHubState();
}

class _ButtonHubState extends State<ButtonHub> {
  final _app = AppSettings.instance;
  final _display = DisplayController.instance;
  final _memories = AppMemories.instante;
  bool editingMode = false;

  @override
  void initState() {
    super.initState();
    _memories.init();
  }

  /// This is the basic method of inserting a key. In general, it inserts
  /// a key at the current cursor position, updating the display.
  void insertKey(KeyModel key) {
    // Gets the display content and selection positions
    String text = _display.controller.text;
    TextSelection selection;
    int startSelection;
    int endSelection;

    (startSelection, endSelection, selection) = _selectionPositions();

    // If there is a text selection, replace the selection with the new character
    if (selection.isValid && startSelection != endSelection) {
      text = StringEdit.insertAtSelectionPosition(
          text, startSelection, key, endSelection);
    } else {
      // Insert character at cursor position
      text = StringEdit.insertAtCurrentPosition(endSelection, text, key);
    }

    if (key.label.contains('(x') || key.label.contains('x±')) {
      int newStart = startSelection + key.offset;
      int newEnd = newStart + 1;
      DisplayControl.updateDisplay(
        _display.controller,
        text,
        TextSelection(baseOffset: newStart, extentOffset: newEnd),
      );
    } else {
      int newPosition = startSelection + key.offset;
      DisplayControl.updateDisplay(
        _display.controller,
        text,
        TextSelection.collapsed(offset: newPosition),
      );
    }

    editingMode = true;
    _display.displayFocusNode.requestFocus();
  }

  void preOperatorsKey(KeyModel key) {
    if (!editingMode && _memories.mAns != 0) {
      _display.controller.text = ansLabel;
      editingMode = true;
    } else if (!editingMode) {
      return;
    }
    insertKey(key);
  }

  void preAnsKey(KeyModel key) {
    if (!editingMode) {
      if (_memories.mAns != 0) {
        _display.controller.clear();
        insertKey(key);
        return;
      } else {
        return;
      }
    }
    _display.controller.text = key.label;
    editingMode = true;
  }

  void preNumbersKey(KeyModel key) {
    if (editingMode) {
      insertKey(key);
    } else {
      //
      _display.controller.clear();
      insertKey(key);
    }
  }

  void insertEEKey(KeyModel key) {
    if (!editingMode) return;

    String text = _display.controller.text;
    int startSelection;

    (startSelection, _, _) = _selectionPositions();

    if (startSelection - 1 >= 0) {
      RegExp regExp = RegExp(r'\d');
      if (regExp.hasMatch(text[startSelection - 1])) {
        insertKey(KeyModel(label: 'e'));
      }
    }
  }

  void equalKey(KeyModel key) {
    if (!editingMode) return;

    try {
      // process expression
      String textExpression = _display.controller.text;
      if (textExpression.isNotEmpty) {
        MathExpression expression = MathExpression.parse(textExpression);

        final result = expression.evaluation();

        // if ok, insert expression in secondary display.
        _display.addInSecondaryDisplay(textExpression);
        _display.controller.clear();
        _display.controller.text = result.toString();
        _memories.mAns = result;
      }
    } catch (e) {
      _display.controller.text = 'Error in expression';
    }

    editingMode = false;
  }

  (int, int, TextSelection) _selectionPositions() {
    TextSelection selection = _display.controller.selection;
    int startSelection = selection.start;
    int endSelection = selection.end;

    startSelection = startSelection == -1 ? 0 : startSelection;
    endSelection = endSelection == -1 ? 0 : endSelection;

    return (startSelection, endSelection, selection);
  }

  void moveKeyKeys(DirectionKeys key) {
    switch (key) {
      case DirectionKeys.left:
        DisplayControl.moveCursorLeft(_display.controller);
        break;
      case DirectionKeys.top:
        // TODO: Handle this case.
        break;
      case DirectionKeys.bottom:
        // TODO: Handle this case.
        break;
      case DirectionKeys.right:
        DisplayControl.moveCursorRight(_display.controller);
    }
  }

  void clearKey() {
    editingMode = false;
    _display.controller.clear();
  }

  /// this method manages the '±' key click, moving through the elements of
  /// a Measure, or even creating one if executed between empty parentheses.
  void pmMeasureKey(KeyModel key) {
    String text = _display.controller.text;
    int position = _display.controller.selection.start;

    // Checks if it is inside a Measure sentence
    int start;
    int end;
    (start, end) = _checkMeasureInCursor(text, position);
    if (start >= 0) {
      String measureString = text.substring(start, end);
      int newSelectionStart = 0;
      int newSelectionEnd = 0;
      (newSelectionStart, newSelectionEnd) = _getMeasureElement(
        measureString,
        position - start,
      );
      DisplayControl.updateDisplay(
        _display.controller,
        text,
        TextSelection(
          baseOffset: start + newSelectionStart,
          extentOffset: start + newSelectionEnd,
        ),
      );
      return;
    }

    if (_itsBetween(text, RegExp(r'\(\)'), position) ||
        _itsBetween(text, RegExp(r'\(x\)'), position)) {
      insertKey(KeyModel(label: measureInLabel, offset: 0));
    }
  }

  // This method returns true if the position is between the outermost
  // characters in the pattern passed by an ER
  bool _itsBetween(String text, RegExp pattern, int position) {
    final allMatches = pattern.allMatches(text);
    for (final match in allMatches) {
      int start = match.start;
      int end = match.end;
      if (position > start && position < end) {
        return true;
      }
    }

    return false;
  }

  // This method returns the selection of the element outside the cursor
  (int, int) _getMeasureElement(String text, int position) {
    RegExp regExp = RegExp(r'(\b\d*\.?\d+\b|x|dx)');
    Iterable<RegExpMatch> allMatches = regExp.allMatches(text);
    int start = -1;
    int end = -1;
    for (var match in allMatches) {
      start = match.start;
      end = match.end;
      // check by element outside the cursor
      if (!(position >= start && position <= end)) {
        break;
      }
      start = end = -1;
    }

    return (start, end);
  }

  // Checks whether the cursor is within a measure sentence and, if so,
  // returns the start and end positions of the sentence.
  (int, int) _checkMeasureInCursor(String text, int position) {
    RegExp regExp = RegExp(r'\((\d*\.?\d+|x)±(\d*\.?\d+|dx)\)');
    Iterable<RegExpMatch> allMatches = regExp.allMatches(text);

    int start = -1;
    int end = -1;
    for (var match in allMatches) {
      start = match.start;
      end = match.end;
      // check by element within the cursor
      if (position > start && position < end) {
        break;
      }
      start = end = -1;
    }

    return (start, end);
  }

  /// Not implemented keys
  void notImplementedKey(KeyModel key) {
    log('Not implemented key: ${key.label}');
  }

  /// This method processes the backspace key (BS). BS must remove entire
  /// phrases such as function names and parentheses without breaking
  /// parentheses pairs.
  void backSpaceKey() {
    int position = _display.controller.selection.baseOffset;
    String text = _display.controller.text;

    // If the cursor is at the beginning of the text, returns
    if (position <= 0) {
      return;
    }

    String? newText;
    int newPosition;

    // Remove function sequence around current position
    (newText, newPosition) =
        StringEdit.tryRemoveSpecialSequence(text, position);

    if (newText == null) {
      String lastCharacter = text[position - 1];
      // If the previous character is a close parenthesis, return the cursor
      // one character.
      if (lastCharacter == '(' || lastCharacter == ')') {
        DisplayControl.moveCursor(_display.controller, position - 1);
        return;
      }
      // Remove last charactere
      newText = StringEdit.removeLastCharacter(text, position);
      newPosition = position - 1;
    }

    // uodate display
    DisplayControl.updateDisplay(
      _display.controller,
      newText,
      TextSelection.collapsed(offset: newPosition),
    );
  }

  /// This method opens the dialog for editing the fix
  void fixKey(KeyModel key) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Precision'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Adjust the number of decimal places for display in results.'),
            FixSpinButton(appSettings: _app),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton.icon(
              style: AppButtonStyles.primaryButton(context),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 5;
        double totalHorizontalPadding = 16 + (crossAxisCount - 1) * 5;
        double buttonWidth =
            (constraints.maxWidth - totalHorizontalPadding) / crossAxisCount;

        int totalButtons = 50;
        int totalRows = (totalButtons / crossAxisCount).ceil();
        double totalVerticalPadding = 8 + (totalRows - 1) * 5;
        double availableHeight = constraints.maxHeight - totalVerticalPadding;
        double buttonHeight = availableHeight / totalRows;

        return GridView.count(
          primary: false,
          padding: const EdgeInsets.all(8),
          crossAxisSpacing: crossAxisCount.toDouble(),
          mainAxisSpacing: 5,
          crossAxisCount: 5,
          childAspectRatio: buttonWidth / buttonHeight,
          children: [
            // 2nd Button
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    secondLabel,
                    // image: 'assets/images/buttons/2nd.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: !_app.secondFunc
                        ? AppColors.buttonSecondFunc
                        : AppColors.buttonSecondFunc.shade900,
                    buttonCallBack: (_) => _app.toggleSecondFunc(),
                  );
                }),
            // Directionals Buttons
            ...CreateButton.directionals(moveKeyKeys),
            // STO Button
            CalcButton(
              stoLabel,
              fontColor: AppColors.fontBlack,
              buttonColor: AppColors.buttonMemories,
              buttonCallBack: notImplementedKey,
            ),
            // Memories Buttons
            ...CreateButton.memories(insertKey),
            // Measure Button
            CalcButton(
              measureLabel,
              image: 'assets/images/buttons/measure.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: insertKey,
            ),
            // Measure pm Button
            CalcButton(
              pmLabel,
              image: 'assets/images/buttons/pm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: pmMeasureKey,
            ),
            // Measure truncate Button
            ListenableBuilder(
              listenable: _app.truncate$,
              builder: (context, _) {
                return CalcButton(
                  '~',
                  image: 'assets/images/buttons/trunc.png',
                  fontColor: AppColors.fontWhite,
                  buttonColor: !_app.truncate
                      ? AppColors.buttonMeasures
                      : AppColors.buttonMeasures.shade900,
                  buttonCallBack: (_) => _app.toggleTruncate(),
                );
              },
            ),
            // 𝚺x Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? sumLabel : rstLabel,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/sumx.png'
                      : null,
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonColor: const Color(0xFF3DD3F8),
                  buttonCallBack: insertKey,
                );
              },
            ),
            // xm Button
            CalcButton(
              xmLabel,
              image: 'assets/images/buttons/xm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: const Color(0xFF3DD3F8),
              buttonCallBack: preNumbersKey,
            ),
            // Abs(x) Button
            CalcButton(
              absLabel,
              image: 'assets/images/buttons/abs.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: preNumbersKey,
            ),
            // ln(x) and exp(x) Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? lnLabel : expLabel,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/ln.png'
                      : 'assets/images/buttons/ex.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // Log(x) and pow10(x) Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? logLabel : pow10Label,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/log.png'
                      : 'assets/images/buttons/tenx.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // - (minus) Button
            CalcButton(
              '-',
              image: 'assets/images/buttons/minusset.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: insertKey,
            ),
            // π (pi) Button
            CalcButton(
              piLabel,
              image: 'assets/images/buttons/pi.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: preNumbersKey,
            ),
            // rad x deg Button
            ListenableBuilder(
              listenable: _app.isRadians$,
              builder: (context, _) {
                return CalcButton(
                  _app.isRadians ? radLabel : degLabel,
                  image: _app.isRadians
                      ? 'assets/images/buttons/rad.png'
                      : 'assets/images/buttons/deg.png',
                  fontColor: _app.isRadians
                      ? AppColors.fontWhite
                      : AppColors.fontGreen,
                  buttonCallBack: (_) => _app.toggleIsRadians(),
                );
              },
            ),
            // sin(x) and asin(x) Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? sinLabel : asinLabel,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/sin.png'
                      : 'assets/images/buttons/sininv.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // cos(x) and acons(x) Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? cosLabel : acosLabel,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/cos.png'
                      : 'assets/images/buttons/cosinv.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // tan(x) and atan(x) Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? tanLabel : atanLabel,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/tan.png'
                      : 'assets/images/buttons/taninv.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // Fix Button
            CalcButton(
              fixLabel,
              image: 'assets/images/buttons/fix.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: fixKey,
            ),
            // pow(x) and (sqr(x) Button)
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? powLabel : sqrLabel,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/x2.png'
                      : 'assets/images/buttons/sqr.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // pow3(x) and sqr3(x) Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? pow3Label : sqr3Label,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/x3.png'
                      : 'assets/images/buttons/sqr3.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // powy(x) and sqry(x) Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? powyLabel : sqryLabel,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/xy.png'
                      : 'assets/images/buttons/sqry.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: preNumbersKey,
                );
              },
            ),
            // (...) Button
            CalcButton(
              parenthesesLabel,
              image: 'assets/images/buttons/parentheses.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: insertKey,
            ),
            // reset Button
            const ResetButton(),
            // 7, 8, and 9 Buttons
            ...CreateButton.numbers('789', preNumbersKey),
            // BS Button
            CalcButton(
              bsLabel,
              // image: 'assets/images/buttons/bs.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: (_) => backSpaceKey(),
            ),
            // CLR Button
            CalcButton(
              clrLabel,
              // image: 'assets/images/buttons/clr.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: (_) => clearKey(),
            ),
            // 4, 5, and 6 Buttons
            ...CreateButton.numbers('456', preNumbersKey),
            // * (multiplication) Button
            CalcButton(
              '*',
              image: 'assets/images/buttons/times.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: preOperatorsKey,
            ),
            // / (division) Button
            CalcButton(
              '/',
              image: 'assets/images/buttons/div.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: preOperatorsKey,
            ),
            // 1, 2, and 3 Buttons
            ...CreateButton.numbers('123', preNumbersKey),
            // + (adiction) Button
            CalcButton(
              '+',
              image: 'assets/images/buttons/plus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: preOperatorsKey,
            ),
            // - (subtraction) Button
            CalcButton(
              '-',
              image: 'assets/images/buttons/minus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: preOperatorsKey,
            ),
            // 0 Button
            CalcButton(
              '0',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: preNumbersKey,
            ),
            // . (point) Button
            CalcButton(
              '.',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: preNumbersKey,
            ),
            // EE Button
            CalcButton(
              'EE',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertEEKey,
            ),
            // Ans Button
            CalcButton(
              ansLabel,
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: preAnsKey,
            ),
            // = Button
            CalcButton(
              '=',
              image: 'assets/images/buttons/eq.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: equalKey,
            ),
          ],
        );
      },
    );
  }
}
