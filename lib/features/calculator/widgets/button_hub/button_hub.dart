import 'package:flutter/material.dart';

import '../../../../common/constants/buttons_label.dart';
import '../../../../common/models/display/display_controller.dart';
import '../../../../common/models/key_model/key_model.dart';
import '../../../../common/models/math_expression/math_expression.dart';
import '../../../../common/models/measure/measure.dart';
import '../../../../common/models/measure/measure_functions.dart';
import '../../../../common/models/measure/statistic.dart';
import '../../../../common/models/memories/app_memories.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/themes/styles/app_button_styles.dart';
import '../../../../common/widgets/fix_spin_button.dart';
import 'calc_button.dart';
import 'utilities/create_button.dart';
import 'utilities/display_utilities.dart';
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
  final _statistics = StatisticController.instance;

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

    if (key.label.contains('(x') ||
        key.label.contains('x±') ||
        key.label.contains('(r,')) {
      int newStart = startSelection + key.offset;
      int newEnd = newStart + 1;
      DisplayUtilities.updateDisplay(
        _display.controller,
        text,
        TextSelection(baseOffset: newStart, extentOffset: newEnd),
      );
    } else {
      int lenght = text.length;
      // Remove operator repetitions
      text = expressionBasicFilter(text);

      int newPosition = startSelection;
      if (text.length == lenght) {
        newPosition += key.offset;
      }
      DisplayUtilities.updateDisplay(
        _display.controller,
        text,
        TextSelection.collapsed(offset: newPosition),
      );
    }

    editingMode = true;
    _display.displayFocusNode.requestFocus();
  }

  String expressionBasicFilter(String text) {
    return text
        .replaceAll('++', '+')
        .replaceAll('--', '-')
        .replaceAll('+-', '-')
        .replaceAll('-+', '+')
        .replaceAll('**', '*')
        .replaceAll('/*', '*')
        .replaceAll('//', '/')
        .replaceAll('*/', '/')
        .replaceAll('+/', '/')
        .replaceAll('/+', '+')
        .replaceAll('-/', '/')
        .replaceAll('/-', '-')
        .replaceAll('+*', '*')
        .replaceAll('*+', '+')
        .replaceAll('-*', '*')
        .replaceAll('*-', '-');
  }

  /// Process operators key
  void preOperatorsKey(KeyModel key) {
    if (!editingMode && _memories.mAns != 0) {
      _display.controller.text = ansLabel;
      editingMode = true;
    } else if (!editingMode) {
      return;
    }
    insertKey(key);
  }

  /// Process Ans key
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
    insertKey(key);
  }

  /// Process a general keys
  void preNumbersKey(KeyModel key) {
    if (editingMode) {
      insertKey(key);
    } else {
      // Clear display and inter a key
      _display.controller.clear();
      insertKey(key);
    }
  }

  /// insert power of 10
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

  /// Process expression in display
  void equalKey(KeyModel key) {
    if (!editingMode) return;
    _app.expressionErrorOff();
    String textExpression = _display.controller.text;

    try {
      // process expression
      if (textExpression.isNotEmpty) {
        MathExpression expression = MathExpression.parse(textExpression);

        final result = expression.evaluation();

        // if ok, insert expression in secondary display.
        _display.addInSecondaryDisplay(textExpression);
        _display.controller.clear();
        _display.controller.text = _formatResult(result);
        if (result is double || result is Measure) {
          _memories.mAns = result;
        }
        _display.resetSecondLine();
        if (_memories.storageOn) {
          _memories.memories[key.label]!.value = result;
          _memories.toogleStorageOn();
          _display.controller.text = '${_formatResult(result)} ￫ ${key.label}';
        }
        editingMode = false;
      }
    } catch (err) {
      _app.expressionErrorOn();
      _display.controller.text = textExpression;
      editingMode = true;
    }
  }

  // Format the output
  String _formatResult(dynamic value) {
    if (value is double) {
      if (_app.fix != -1) {
        return value.toStringAsFixed(_app.fix);
      }
      return _removeTrailingZeros(value);
    } else if (value is Measure) {
      if (_app.truncate) {
        return value.truncate();
      } else {
        if (_app.fix != -1) {
          return value.toStringAsFixed(_app.fix);
        }
        return value.toStringByFunc(_removeTrailingZeros);
      }
    } else if (value is PolarRepresentation || value is RectRepresentation) {
      if (_app.fix != -1) {
        return value.toStringAsFixed(_app.fix);
      }
      return value.toStringByFunc(_removeTrailingZeros);
    } else {
      return 'Error!';
    }
  }

  // Remove all tralling zeros from a double value string representation
  String _removeTrailingZeros(double value) {
    String cleanValue = value.toStringAsFixed(10);
    if (cleanValue.contains('.')) {
      cleanValue = cleanValue.replaceAll(RegExp(r'0*$'), '');
      cleanValue = cleanValue.replaceAll(RegExp(r'\.$'), '');
    }
    return cleanValue;
  }

  // Returns the indices of the selected text and the TextSelection of the
  // TextEditingController in _display.controller
  (int, int, TextSelection) _selectionPositions() {
    TextSelection selection = _display.controller.selection;
    int startSelection = selection.start;
    int endSelection = selection.end;

    startSelection = startSelection == -1 ? 0 : startSelection;
    endSelection = endSelection == -1 ? 0 : endSelection;

    return (startSelection, endSelection, selection);
  }

  /// Process movement keys
  void moveKeyKeys(DirectionKeys key) {
    switch (key) {
      case DirectionKeys.left:
        DisplayUtilities.moveCursorLeft(_display.controller);
        break;
      case DirectionKeys.top:
        DisplayUtilities.moveHistoryUp(_display);
        if (_display.controller.text.isNotEmpty) editingMode = true;
        break;
      case DirectionKeys.bottom:
        DisplayUtilities.modeHistoryDown(_display);
        if (_display.controller.text.isNotEmpty) editingMode = true;
        break;
      case DirectionKeys.right:
        DisplayUtilities.moveCursorRight(_display.controller);
    }
  }

  /// clear display
  void clearKey() {
    editingMode = false;
    _display.controller.clear();
  }

  /// this method manages the '(x±dx)' key click.
  void measureKey(KeyModel key) {
    String text = _display.controller.text;
    int position = _display.controller.selection.start;

    final KeyModel newKey =
        _itsBetweenRegExp(text, RegExp(r'\(\)'), position) ||
                _itsBetweenRegExp(text, RegExp(r'\(x\)'), position)
            ? KeyModel(label: measureInLabel, offset: 0)
            : key;

    if (editingMode) {
      insertKey(newKey);
    } else {
      // Clear display and inter a key
      _display.controller.clear();
      insertKey(newKey);
    }
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
      DisplayUtilities.updateDisplay(
        _display.controller,
        text,
        TextSelection(
          baseOffset: start + newSelectionStart,
          extentOffset: start + newSelectionEnd,
        ),
      );
      return;
    }

    if (_itsBetweenRegExp(text, RegExp(r'\(\)'), position) ||
        _itsBetweenRegExp(text, RegExp(r'\(x\)'), position)) {
      insertKey(KeyModel(label: measureInLabel, offset: 0));
    }
  }

  /// Storage display value in the memory
  void storageMemoryKey(KeyModel key) {
    _memories.toogleStorageOn();
    if (!_memories.storageOn) return;
  }

  /// Process letters memories keys
  void memoriesLettersKey(KeyModel key) {
    if (!_memories.storageOn) {
      preNumbersKey(key);
    } else {
      if (!editingMode) {
        clearKey();
        editingMode = true;
        insertKey(
          KeyModel(label: 'Ans', offset: 3),
        );
      }
      equalKey(key);
    }
  }

  /// Add value in display to statistic stack
  void addStackKey(KeyModel key) {
    if (key.label == sumLabel) {
      String text = _display.controller.text;

      final value = _getCalculatorValue(text);
      if (value != null) {
        _statistics.add(value);
        _display.controller.text = _statistics.values.toString();
      } else {
        if (!editingMode) {
          _display.controller.clear();
          _display.controller.text = _statistics.values.toString();
        }
        return;
      }
      editingMode = false;
    }
  }

  void showStack() {
    if (_statistics.isNotEmpty) {
      editingMode = false;
      _display.controller.clear();
      _display.controller.text = _statistics.values.toString();
    }
  }

  /// Remove a value from statistic stack
  void removeStakKey(KeyModel key) {
    if (_statistics.isNotEmpty) {
      _statistics.removeLast();
      _display.controller.text = _statistics.values.toString();
      _app.toggleSecondFunc();
      editingMode = false;
    }
  }

  /// Calculate and insert the mean in display
  void meanKey(KeyModel key) {
    if (key.label == xmLabel) {
      if (_statistics.isEmpty) return;

      if (!editingMode) {
        _display.controller.clear();
      }

      String value = _statistics.mean.toString();
      value = editingMode ? value = value.replaceAll(' ', '') : value;
      insertKey(KeyModel(label: value, offset: value.length));
    }
  }

  /// Clear statistic stack
  void clearStatKey(KeyModel key) {
    _statistics.clear();
    editingMode = false;
    _display.controller.text = '-- Stat Stack is Clean --';
    _app.toggleSecondFunc();
  }

  double? _getCalculatorValue(String text) {
    if (text == '') return null;

    if (!editingMode) {
      if (_memories.mAns != 0) {
        return _getValue(_memories.mAns);
      }
    } else {
      final value = double.tryParse(text);
      if (value != null) {
        editingMode = false;
        return value;
      } else {
        final measure = Measure.tryParse(text);
        if (measure != null) {
          editingMode = false;
          return measure.value;
        } else {
          equalKey(KeyModel(label: '_'));
          return _getValue(_memories.mAns);
        }
      }
    }
    return null;
  }

  // returne a value of a Measure or a varlue from a double
  double _getValue(dynamic value) {
    if (value is Measure) {
      return value.value;
    }
    return value;
  }

  // This method returns true if the position is between the outermost
  // characters in the pattern passed by an ER
  bool _itsBetweenRegExp(String text, RegExp pattern, int position) {
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
    // RegExp regExp = RegExp(r'(\d*\.?\d+|x|dx)');
    RegExp regExp = RegExp(r'(-?\d*\.?\d+(e[+\-]?\d+)?|x|dx)');
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
    RegExp regExp = RegExp(
        r'\((-?\d*\.?\d+(e[+\-]?\d+)?|x)±(-?\d*\.?\d+(e[+\-]?\d+)?|dx)\)');
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
        DisplayUtilities.moveCursor(_display.controller, position - 1);
        return;
      }
      // Remove last charactere
      newText = StringEdit.removeLastCharacter(text, position);
      newPosition = position - 1;
    }

    // uodate display
    DisplayUtilities.updateDisplay(
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Adjust the number of decimal places for display in results.'),
            FixSpinButton(),
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
            // ---------------------------------------------------------
            // 2nd Button
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    secondLabel,
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: !_app.secondFunc
                        ? AppColors.buttonSecondFunc
                        : AppColors.buttonSecondFunc.shade900,
                    onPress: (_) => _app.toggleSecondFunc(),
                  );
                }),
            // Directionals Buttons
            ...CreateButton.directionals(moveKeyKeys),
            // ---------------------------------------------------------
            // STO Button
            ListenableBuilder(
                listenable: _memories.storageOn$,
                builder: (context, _) {
                  return CalcButton(
                    stoLabel,
                    fontColor: _memories.storageOn
                        ? AppColors.fontOrange
                        : AppColors.fontWhite,
                    buttonColor: AppColors.buttonMemories,
                    onPress: storageMemoryKey,
                  );
                }),
            // Memories Buttons A-H
            ...CreateButton.memories(memoriesLettersKey),
            // ---------------------------------------------------------
            // Measure Button
            CalcButton(
              measureLabel,
              image: 'assets/images/buttons/measure.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              onPress: measureKey,
            ),
            // Measure pm Button
            CalcButton(
              pmLabel,
              image: 'assets/images/buttons/pm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              onPress: pmMeasureKey,
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
                  onPress: (_) => _app.toggleTruncate(),
                );
              },
            ),
            // 𝚺x Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) {
                return CalcButton(
                  !_app.secondFunc ? sumLabel : rstLabel,
                  useImageColor: true,
                  image: !_app.secondFunc
                      ? 'assets/images/buttons/addStack.png'
                      : 'assets/images/buttons/removeStack.png',
                  fontColor: !_app.secondFunc
                      ? AppColors.fontWhite
                      : AppColors.fontYellow,
                  buttonColor: AppColors.buttonStatistics,
                  onPress: !_app.secondFunc ? addStackKey : removeStakKey,
                  onLongPress: showStack,
                );
              },
            ),
            // xm Button
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    !_app.secondFunc ? xmLabel : clearLabel,
                    useImageColor: !_app.secondFunc ? false : true,
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/xm.png'
                        : 'assets/images/buttons/clearStack.png',
                    fontColor: AppColors.fontWhite,
                    buttonColor: AppColors.buttonStatistics,
                    onPress: !_app.secondFunc ? meanKey : clearStatKey,
                  );
                }),
            // ---------------------------------------------------------
            // Fix Button
            CalcButton(
              fixLabel,
              image: 'assets/images/buttons/fix.png',
              fontColor: AppColors.fontWhite,
              onPress: fixKey,
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
                  onPress: (_) => _app.toggleIsRadians(),
                );
              },
            ),
            // π (pi) Button
            CalcButton(
              piLabel,
              image: 'assets/images/buttons/pi.png',
              fontColor: AppColors.fontWhite,
              onPress: preNumbersKey,
            ),
            // Abs(x) Button
            CalcButton(
              absLabel,
              image: 'assets/images/buttons/abs.png',
              fontColor: AppColors.fontWhite,
              onPress: preNumbersKey,
            ),
            // Pol/Rec Button
            ListenableBuilder(
              listenable: _app.secondFunc$,
              builder: (context, _) => CalcButton(
                _app.secondFunc ? recLabel : polLabel,
                image: _app.secondFunc
                    ? 'assets/images/buttons/rec.png'
                    : 'assets/images/buttons/pol.png',
                fontColor: !_app.secondFunc
                    ? AppColors.fontWhite
                    : AppColors.fontYellow,
                onPress: preNumbersKey,
              ),
            ),
            // ---------------------------------------------------------
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
                  onPress: preNumbersKey,
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
                  onPress: preNumbersKey,
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
                  onPress: preNumbersKey,
                );
              },
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
                  onPress: preNumbersKey,
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
                  onPress: preNumbersKey,
                );
              },
            ),
            // ---------------------------------------------------------
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
                  onPress: preNumbersKey,
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
                  onPress: preNumbersKey,
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
                  onPress: preNumbersKey,
                );
              },
            ),
            // (...) Button
            CalcButton(
              parenthesesLabel,
              image: 'assets/images/buttons/parentheses.png',
              fontColor: AppColors.fontWhite,
              onPress: insertKey,
            ),
            // - (minus) Button
            CalcButton(
              '-',
              image: 'assets/images/buttons/minusset.png',
              fontColor: AppColors.fontWhite,
              onPress: insertKey,
            ),
            // ---------------------------------------------------------
            // 7, 8, and 9 Buttons
            ...CreateButton.numbers('789', preNumbersKey),
            // BS Button
            CalcButton(
              bsLabel,
              // image: 'assets/images/buttons/bs.png',
              iconData: Icons.backspace,
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              iconColor: AppColors.fontWhite,
              onPress: (_) => backSpaceKey(),
            ),
            // CLR Button
            CalcButton(
              clrLabel,
              // image: 'assets/images/buttons/clr.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              onPress: (_) => clearKey(),
            ),
            // ---------------------------------------------------------
            // 4, 5, and 6 Buttons
            ...CreateButton.numbers('456', preNumbersKey),
            // * (multiplication) Button
            CalcButton(
              '*',
              image: 'assets/images/buttons/times.png',
              buttonColor: AppColors.buttonBasics,
              onPress: preOperatorsKey,
            ),
            // / (division) Button
            CalcButton(
              '/',
              image: 'assets/images/buttons/div.png',
              buttonColor: AppColors.buttonBasics,
              onPress: preOperatorsKey,
            ),
            // ---------------------------------------------------------
            // 1, 2, and 3 Buttons
            ...CreateButton.numbers('123', preNumbersKey),
            // + (adiction) Button
            CalcButton(
              '+',
              image: 'assets/images/buttons/plus.png',
              buttonColor: AppColors.buttonBasics,
              onPress: preOperatorsKey,
            ),
            // - (subtraction) Button
            CalcButton(
              '-',
              image: 'assets/images/buttons/minus.png',
              buttonColor: AppColors.buttonBasics,
              onPress: preOperatorsKey,
            ),
            // ---------------------------------------------------------
            // 0 Button
            CalcButton(
              '0',
              buttonColor: AppColors.buttonBasics,
              onPress: preNumbersKey,
            ),
            // . (point) Button
            CalcButton(
              '.',
              buttonColor: AppColors.buttonBasics,
              onPress: preNumbersKey,
            ),
            // EE Button
            CalcButton(
              'EE',
              buttonColor: AppColors.buttonBasics,
              onPress: insertEEKey,
            ),
            // Ans Button
            CalcButton(
              ansLabel,
              buttonColor: AppColors.buttonBasics,
              onPress: preAnsKey,
            ),
            // = Button
            CalcButton(
              '=',
              image: 'assets/images/buttons/eq.png',
              buttonColor: AppColors.buttonBasics,
              onPress: equalKey,
            ),
          ],
        );
      },
    );
  }
}
