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
  final _display = DisplayController.instance;
  double _fontSize = AppTextStyle.textStyleDisplay.fontSize!;

  @override
  void initState() {
    super.initState();
    _display.init();
    _display.controller.addListener(_adjustFontSize);
  }

  void _adjustFontSize() {
    setState(() {
      int lenght = _display.controller.text.length;
      if (lenght > 54) {
        _fontSize = 16;
      } else {
        _fontSize = AppTextStyle.textStyleDisplay.fontSize!;
      }
    });
  }

  @override
  void dispose() {
    _display.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorSheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 0),
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
            flex: 10,
            child: ListenableBuilder(
              listenable: _display.secondary$,
              builder: (context, _) {
                return ListView.builder(
                  controller: _display.scrollController,
                  itemCount: _display.secondary.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _display.secondary[index],
                      style: AppTextStyle.textStyleSecondDisplay.copyWith(
                        color: _display.secondaryLine == index
                            ? AppColors.fontYellow
                            : null,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 20,
            child: TextField(
              scrollPadding: const EdgeInsets.all(0),
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
              maxLines: 3,
              style: AppTextStyle.textStyleDisplay.copyWith(
                fontSize: _fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
