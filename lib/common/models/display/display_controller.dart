import 'package:flutter/material.dart';

class DisplayController {
  DisplayController._();
  static final _instance = DisplayController._();
  static DisplayController get instance => _instance;
  late FocusNode displayFocusNode;

  final controller = TextEditingController(text: '');
  final stackLines$ = ValueNotifier<List<String>>([]);

  String get text => controller.text;

  List<String> get stackLines => stackLines$.value;

  void init() {
    displayFocusNode = FocusNode();
  }

  void dispose() {
    displayFocusNode.dispose();
    stackLines$.dispose();
  }
}
