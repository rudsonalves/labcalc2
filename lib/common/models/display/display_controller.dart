import 'package:flutter/material.dart';

class DisplayController {
  DisplayController._();
  static final _instance = DisplayController._();
  static DisplayController get instance => _instance;

  late FocusNode displayFocusNode;

  final controller = TextEditingController(text: '');
  String get text => controller.text;

  final secondary$ = ValueNotifier<List<String>>([]);

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  List<String> get secondary => secondary$.value;

  int _secondaryLine = -1;

  int get secondaryLine => _secondaryLine;

  String get downSecondLine {
    // if there is no line selected, select the last one from the secondary list
    if (_secondaryLine == -1) {
      if (secondary.isNotEmpty) {
        // select the last line from secondary list
        _secondaryLine = secondary.length - 1;
      } else {
        // if the secondary list is empty return ''
        return '';
      }
    } else if (_secondaryLine > 0) {
      // select the next line
      _secondaryLine--;
    }
    selectHistoryLine(_secondaryLine);
    return secondary[_secondaryLine];
  }

  String get upSecondLine {
    // if there is no line selected, select the last one from the secondary list
    if (_secondaryLine == -1) {
      if (secondary.isNotEmpty) {
        // select the first line from secondary list
        _secondaryLine = 0;
      } else {
        // if the secondary list is empty return ''
        return '';
      }
    } else if (_secondaryLine < secondary.length - 1) {
      // select the previous line
      _secondaryLine++;
    }
    selectHistoryLine(_secondaryLine);
    return secondary[_secondaryLine];
  }

  void selectHistoryLine(int index) {
    if (_scrollController.hasClients && secondary.isNotEmpty) {
      const itemHeight = 21.0;

      final position = itemHeight * index;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void init() {
    displayFocusNode = FocusNode();
  }

  void dispose() {
    displayFocusNode.dispose();
    secondary$.dispose();
    _scrollController.dispose();
    controller.dispose();
  }

  void addInSecondaryDisplay(String expression) {
    secondary$.value.add(expression);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    secondary$.notifyListeners(); // Notifies listeners about the change

    // Scroll to the end of the list
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  void resetSecondaryDisplay() {
    secondary$.value.clear();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    secondary$.notifyListeners(); // Notifies listeners about the change
  }

  void resetDisplay() {
    resetSecondaryDisplay();
    controller.clear();
  }

  void resetSecondLine() => _secondaryLine = -1;
}
