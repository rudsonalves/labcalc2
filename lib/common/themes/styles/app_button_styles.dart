import 'package:flutter/material.dart';

class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle primaryButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.secondary;
    final onPrimary = colorScheme.onPrimary;

    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primary),
        foregroundColor: MaterialStateProperty.all(onPrimary));
  }
}
