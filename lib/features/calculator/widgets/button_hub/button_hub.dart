import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../common/models/display/display_controller.dart';
import '../../../../common/models/key_model/key_model.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/widgets/fix_spin_button.dart';
import 'calc_button.dart';
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

  void insertKey(KeyModel key) {
    String text = _display.controller.text;
    TextSelection selection = _display.controller.selection;

    int startPositionSelection = selection.start;
    int endPositionSelection = selection.end;

    startPositionSelection =
        startPositionSelection == -1 ? 0 : startPositionSelection;
    endPositionSelection =
        endPositionSelection == -1 ? 0 : endPositionSelection;

    if (text == '0') {
      text = '';
      startPositionSelection = endPositionSelection = 0;
    }

    // If there is a text selection, replace the selection with the new character
    if (selection.isValid && startPositionSelection != endPositionSelection) {
      text = StringEdit.insertAtSelectionPosition(
          text, startPositionSelection, key, endPositionSelection);
    } else {
      // Insert character at cursor position
      text =
          StringEdit.insertAtCurrentPosition(endPositionSelection, text, key);
    }

    if (key.label.contains('(x')) {
      int newStart = startPositionSelection + key.offset;
      int newEnd = newStart + 1;
      DisplayControl.updateDisplay(
        _display.controller,
        text,
        TextSelection(baseOffset: newStart, extentOffset: newEnd),
      );
    } else {
      int newPosition = startPositionSelection + key.offset;
      DisplayControl.updateDisplay(
        _display.controller,
        text,
        TextSelection.collapsed(offset: newPosition),
      );
    }
    _display.displayFocusNode.requestFocus();
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
    _display.controller.text = '';
  }

  void pmKey(KeyModel key) {
    String text = _display.controller.text;
    int startSelection = _display.controller.selection.start;

    RegExp regExp = RegExp(r'^[0-9.]*±([0-9.]|dx)*');
    RegExpMatch? match = regExp.firstMatch(text.substring(startSelection));

    if (match != null) {
      int newPosition = text.indexOf('±', startSelection);
      DisplayControl.moveCursor(_display.controller, newPosition);
      DisplayControl.moveCursorRight(_display.controller);
    }
  }

  void notImplementedKey(KeyModel key) {
    log('Not implemented key: ${key.label}');
  }

  void backSpaceKey() {
    int position = _display.controller.selection.baseOffset;
    String text = _display.controller.text;

    if (position <= 0) {
      return;
    }

    String? newText;
    int newPosition;

    (newText, newPosition) =
        StringEdit.tryRemoveSpecialSequence(text, position);

    if (newText == null) {
      String lastCharacter = text.substring(position - 1, position);
      if (lastCharacter == '(' || lastCharacter == ')') {
        DisplayControl.moveCursor(_display.controller, position - 1);
        return;
      }
      newText = StringEdit.removeLastCharacter(text, position);
      newPosition = position - 1;
    }

    DisplayControl.updateDisplay(
      _display.controller,
      newText,
      TextSelection.collapsed(offset: newPosition),
    );
  }

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
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
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
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    '2nd',
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
            ...CreateButton.directionals(moveKeyKeys),
            CalcButton(
              'STO',
              fontColor: AppColors.fontBlack,
              buttonColor: AppColors.buttonMemories,
              buttonCallBack: notImplementedKey,
            ),
            ...CreateButton.memories(insertKey),
            CalcButton(
              '(x±dx)',
              image: 'assets/images/buttons/measure.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              '±',
              image: 'assets/images/buttons/pm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: pmKey,
            ),
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
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    !_app.secondFunc ? '𝚺x' : 'Rst',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/sumx.png'
                        : null,
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: const Color(0xFF3DD3F8),
                    buttonCallBack: insertKey,
                  );
                }),
            CalcButton(
              'xm',
              image: 'assets/images/buttons/xm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: const Color(0xFF3DD3F8),
              buttonCallBack: insertKey,
            ),
            CalcButton(
              'abs(x)',
              image: 'assets/images/buttons/abs.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: insertKey,
            ),
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'ln(x)' : 'exp(x)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/ln.png'
                      : 'assets/images/buttons/ex.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'log(x)' : 'po10(x)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/log.png'
                      : 'assets/images/buttons/tenx.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            CalcButton(
              '-',
              image: 'assets/images/buttons/minusset.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              'π',
              image: 'assets/images/buttons/pi.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: insertKey,
            ),
            ListenableBuilder(
              listenable: _app.isRadians$,
              builder: (context, _) {
                return CalcButton(
                  _app.isRadians ? 'rad' : 'deg',
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
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'sin(x)' : 'asin(x)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/sin.png'
                      : 'assets/images/buttons/sininv.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'cos(x)' : 'acos(x)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/cos.png'
                      : 'assets/images/buttons/cosinv.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'tan(x)' : 'atan(x)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/tan.png'
                      : 'assets/images/buttons/taninv.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            CalcButton(
              'Fix',
              image: 'assets/images/buttons/fix.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: fixKey,
            ),
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'pow(x)' : 'sqr(x)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/x2.png'
                      : 'assets/images/buttons/sqr.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'pow3(x)' : 'sqr3(x)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/x3.png'
                      : 'assets/images/buttons/sqr3.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? 'powy(x,y)' : 'sqry(x,y)',
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/xy.png'
                      : 'assets/images/buttons/sqry.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonCallBack: insertKey,
                );
              },
            ),
            CalcButton(
              '(x)',
              image: 'assets/images/buttons/parentheses.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              '???',
              // image: 'assets/images/buttons/close.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: notImplementedKey,
            ),
            ...CreateButton.numbers('789', insertKey),
            CalcButton(
              'BS',
              // image: 'assets/images/buttons/bs.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: (_) => backSpaceKey(),
            ),
            CalcButton(
              'CLR',
              // image: 'assets/images/buttons/clr.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: (_) => clearKey(),
            ),
            ...CreateButton.numbers('456', insertKey),
            CalcButton(
              '*',
              image: 'assets/images/buttons/times.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              '/',
              image: 'assets/images/buttons/div.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            ...CreateButton.numbers('123', insertKey),
            CalcButton(
              '+',
              image: 'assets/images/buttons/plus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              '-',
              image: 'assets/images/buttons/minus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              '0',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              '.',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              'EE',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              'ANS',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
            CalcButton(
              '=',
              image: 'assets/images/buttons/eq.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: insertKey,
            ),
          ],
        );
      },
    );
  }
}
