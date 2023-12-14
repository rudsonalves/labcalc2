import 'package:flutter/material.dart';

import '../../../../common/themes/styles/app_text_styles.dart';

class DisplayWidget extends StatefulWidget {
  const DisplayWidget({super.key});

  @override
  State<DisplayWidget> createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends State<DisplayWidget> {
  final List<String> _displayLines = [];
  final displayController = TextEditingController(text: '123.456');

  List<String> get displayLines => _displayLines;

  @override
  Widget build(BuildContext context) {
    final colorSheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: colorSheme.outlineVariant,
        border: Border.all(
          color: colorSheme.secondary,
          width: 1,
        ),
      ),
      child: TextField(
        controller: displayController,
        readOnly: true,
        showCursor: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '0',
        ),
        textAlign: TextAlign.right,
        style: AppTextStyle.textStyleDisplay,
      ),
    );
  }
}
