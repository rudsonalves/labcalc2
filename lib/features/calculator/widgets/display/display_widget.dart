import 'package:flutter/material.dart';

import '../../../../common/models/display/display_controller.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/themes/styles/app_text_styles.dart';

class DisplayWidget extends StatefulWidget {
  const DisplayWidget({super.key});

  @override
  State<DisplayWidget> createState() => _DisplayWidgetState();
}

class _DisplayWidgetState extends State<DisplayWidget> {
  final List<String> _displayLines = [];
  final _display = DisplayController.instance;

  List<String> get displayLines => _displayLines;

  @override
  void initState() {
    super.initState();
    _display.init();
  }

  @override
  void dispose() {
    _display.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorSheme = Theme.of(context).colorScheme;
    List<String> lines = ['25*sin(1.234)', '18*(1+3)', 'atan(1.234)'];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: lines.length,
              itemBuilder: (context, index) {
                return Text(
                  lines[index],
                  style: AppTextStyle.textStyleSecondDisplay,
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
          TextField(
            controller: _display.controller,
            focusNode: _display.displayFocusNode,
            cursorColor: AppColors.fontYellow,
            readOnly: true,
            showCursor: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '0',
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
            style: AppTextStyle.textStyleDisplay,
          ),
        ],
      ),
    );
  }
}
