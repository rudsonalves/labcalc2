import 'package:flutter/material.dart';
import 'package:labcalc2/common/widgets/fix_spin_button.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/models/display/display_controller.dart';
import '../../../../common/models/key_model/key_model.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import 'calc_button.dart';

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

  void _insertKey(KeyModel key) {
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
      text = _insertAtSelectionPosition(
          text, startPositionSelection, key, endPositionSelection);
    } else {
      // Insert character at cursor position
      text = _insertAtCurrentPosition(endPositionSelection, text, key);
    }

    if (key.label.contains('(x')) {
      int newStart = startPositionSelection + key.offset;
      int newEnd = newStart + 1;
      _updateDisplay(
        text,
        TextSelection(baseOffset: newStart, extentOffset: newEnd),
      );
    } else {
      int newPosition = startPositionSelection + key.offset;
      _updateDisplay(text, TextSelection.collapsed(offset: newPosition));
    }
    _display.displayFocusNode.requestFocus();
  }

  String _insertAtSelectionPosition(String text, int startPositionSelection,
      KeyModel key, int endPositionSelection) {
    text = text.substring(0, startPositionSelection) +
        key.label +
        text.substring(endPositionSelection, text.length);
    return text;
  }

  String _insertAtCurrentPosition(
      int endPositionSelection, String text, KeyModel key) {
    if (endPositionSelection == text.length) {
      text += key.label;
    } else {
      text = text.substring(0, endPositionSelection) +
          key.label +
          text.substring(endPositionSelection, text.length);
    }
    return text;
  }

  void _moveKeyButtons(DirectionKeys key) {
    switch (key) {
      case DirectionKeys.left:
        _moveCursorLeft();
        break;
      case DirectionKeys.top:
        // TODO: Handle this case.
        break;
      case DirectionKeys.bottom:
        // TODO: Handle this case.
        break;
      case DirectionKeys.right:
        _moveCursorRight();
    }
  }

  void _moveCursorLeft() {
    String text = _display.controller.text;
    int startSelection = _display.controller.selection.start;

    RegExp regExp = RegExp(r',y|±dx|\(x');
    RegExpMatch? match =
        regExp.allMatches(text.substring(0, startSelection)).lastOrNull;

    if (match != null) {
      int startSelection = match.start + 1;
      int offset = match.end - match.start - 1;
      _updateDisplay(
        text,
        TextSelection(
            baseOffset: startSelection, extentOffset: startSelection + offset),
      );
    } else {
      _moveCursor(startSelection - 1);
    }
  }

  void _moveCursorRight() {
    String text = _display.controller.text;
    int startSelection = _display.controller.selection.start;
    int endSelection = _display.controller.selection.end;

    RegExp regExp = RegExp(r'x,|x±|y\)|dx\)|x\)');
    RegExpMatch? match = regExp.firstMatch(text.substring(endSelection));

    if (match != null) {
      startSelection = endSelection + match.start;
      int offset = match.end - match.start - 1;

      _updateDisplay(
        text,
        TextSelection(
            baseOffset: startSelection, extentOffset: startSelection + offset),
      );
    } else {
      _moveCursor(endSelection + 1);
    }
  }

  void _moveCursor(int position) {
    if (position < 0 || position > _display.controller.text.length) return;
    _display.controller.selection =
        TextSelection.fromPosition(TextPosition(offset: position));
  }

  void _clearButton() {
    _display.controller.text = '';
  }

  void _pmButton(KeyModel key) {
    String text = _display.controller.text;
    int startSelection = _display.controller.selection.start;

    RegExp regExp = RegExp(r'^[0-9.]*±([0-9.]|dx)*');
    RegExpMatch? match = regExp.firstMatch(text.substring(startSelection));

    if (match != null) {
      int newPosition = text.indexOf('±', startSelection);
      _moveCursor(newPosition);
      _moveCursorRight();
    }
  }

  void _backSpaceButton() {
    int position = _display.controller.selection.baseOffset;
    String text = _display.controller.text;

    if (position <= 0) {
      return;
    }

    String? newText;
    int newPosition;

    (newText, newPosition) = _tryRemoveSpecialSequence(text, position);

    if (newText == null) {
      String lastCharacter = text.substring(position - 1, position);
      if (lastCharacter == '(' || lastCharacter == ')') {
        _moveCursor(position - 1);
        return;
      }
      newText = _removeLastCharacter(text, position);
      newPosition = position - 1;
    }

    _updateDisplay(newText, TextSelection.collapsed(offset: newPosition));
  }

  void _fixButton(KeyModel key) async {
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

  (String?, int) _tryRemoveSpecialSequence(String text, int position) {
    for (String seq in removalSeq) {
      int seqLength = seq.length;

      int startPos = position - seqLength;
      startPos = startPos < 0 ? 0 : startPos;

      int endPos = position + (seqLength - 1);
      endPos = endPos > text.length ? text.length : endPos;

      String subString = text.substring(startPos, endPos);

      if (subString.contains(seq)) {
        int offset = subString.indexOf(seq);

        text = text.substring(0, offset + startPos) +
            text.substring(offset + startPos + seqLength);
        position = offset + startPos;
        return (text, position);
      }
    }
    return (null, -1);
  }

  String _removeLastCharacter(text, position) {
    return text.substring(0, position - 1) + text.substring(position);
  }

  void _updateDisplay(String text, TextSelection newSelection) {
    _display.controller.text = text;
    _display.controller.selection = newSelection;
  }

  List<Widget> _createDirectionalButtons() {
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
              buttonCallBack: (_) => _moveKeyButtons(directionsMap[key]!),
            ))
        .toList();
  }

  List<Widget> _createMemoryButtons() {
    int aMemory = 'A'.runes.first;
    int fMemory = 'E'.runes.first;

    List<Widget> buttons = [];

    for (int i = 0; i < 4; i++) {
      buttons.add(
        ListenableBuilder(
          listenable: _app.secondFunc$,
          builder: (context, _) {
            return CalcButton(
              !_app.secondFunc
                  ? String.fromCharCode(aMemory + i)
                  : String.fromCharCode(fMemory + i),
              fontColor:
                  !_app.secondFunc ? AppColors.fontBlack : AppColors.fontYellow,
              buttonColor: AppColors.buttonMemories,
              buttonCallBack: _insertKey,
            );
          },
        ),
      );
    }

    return buttons;
  }

  List<Widget> _createNumbersButtons(String numbers) {
    List<Widget> buttons = [];
    for (String number in numbers.split('')) {
      buttons.add(
        CalcButton(
          number,
          buttonColor: AppColors.buttonBasics,
          buttonCallBack: _insertKey,
        ),
      );
    }

    return buttons;
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
            ..._createDirectionalButtons(),
            CalcButton(
              'STO',
              // image: 'assets/images/buttons/sto.png',
              fontColor: AppColors.fontBlack,
              buttonColor: AppColors.buttonMemories,
              buttonCallBack: _insertKey,
            ),
            ..._createMemoryButtons(),
            CalcButton(
              '(x±dx)',
              image: 'assets/images/buttons/measure.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              '±',
              image: 'assets/images/buttons/pm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: _pmButton,
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
                    buttonCallBack: _insertKey,
                  );
                }),
            CalcButton(
              'xm',
              image: 'assets/images/buttons/xm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: const Color(0xFF3DD3F8),
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              'abs(x)',
              image: 'assets/images/buttons/abs.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: _insertKey,
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
                  buttonCallBack: _insertKey,
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
                  buttonCallBack: _insertKey,
                );
              },
            ),
            CalcButton(
              '-',
              image: 'assets/images/buttons/minusset.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              'π',
              image: 'assets/images/buttons/pi.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: _insertKey,
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
                  buttonCallBack: _insertKey,
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
                  buttonCallBack: _insertKey,
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
                  buttonCallBack: _insertKey,
                );
              },
            ),
            CalcButton(
              'Fix',
              image: 'assets/images/buttons/fix.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: _fixButton,
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
                  buttonCallBack: _insertKey,
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
                  buttonCallBack: _insertKey,
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
                  buttonCallBack: _insertKey,
                );
              },
            ),
            CalcButton(
              '(x)',
              image: 'assets/images/buttons/parentheses.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              '...',
              // image: 'assets/images/buttons/close.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: _insertKey,
            ),
            ..._createNumbersButtons('789'),
            CalcButton(
              'BS',
              // image: 'assets/images/buttons/bs.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: (_) => _backSpaceButton(),
            ),
            CalcButton(
              'CLR',
              // image: 'assets/images/buttons/clr.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: (_) => _clearButton(),
            ),
            ..._createNumbersButtons('456'),
            CalcButton(
              '*',
              image: 'assets/images/buttons/times.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              '/',
              image: 'assets/images/buttons/div.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            ..._createNumbersButtons('123'),
            CalcButton(
              '+',
              image: 'assets/images/buttons/plus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              '-',
              image: 'assets/images/buttons/minus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              '0',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              '.',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              'EE',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              'ANS',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
            CalcButton(
              '=',
              image: 'assets/images/buttons/eq.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: _insertKey,
            ),
          ],
        );
      },
    );
  }
}
