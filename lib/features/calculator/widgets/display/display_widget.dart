// Copyright (C) 2024 Rudson Alves
// 
// This file is part of labcalc2.
// 
// labcalc2 is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// labcalc2 is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with labcalc2.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';

import '../../../../common/models/display/display_controller.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/themes/styles/app_text_styles.dart';

class DisplayWidget extends StatefulWidget {
  final bool erroMode;

  const DisplayWidget({
    super.key,
    required this.erroMode,
  });

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
      if (lenght > 64) {
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
          color: widget.erroMode ? AppColors.fontRed : colorSheme.secondary,
          width: widget.erroMode ? 3 : 1,
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
