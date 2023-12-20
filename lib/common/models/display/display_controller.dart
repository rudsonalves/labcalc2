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
}
