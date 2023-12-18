import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

import '../../../../common/models/key_model/key_model.dart';
import '../../../../common/themes/styles/app_text_styles.dart';

class CalcButton extends StatelessWidget {
  final String? image;
  final Color buttonColor;
  final Color fontColor;
  final void Function(KeyModel key) buttonCallBack;
  final KeyModel keyModel;

  CalcButton(
    String label, {
    Key? key,
    this.image,
    this.buttonColor = Colors.grey,
    this.fontColor = Colors.black,
    required this.buttonCallBack,
  })  : keyModel = KeyModel.fromLabel(label),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () => buttonCallBack(keyModel),
        splashColor: buttonColor.lighter(20),
        borderRadius: BorderRadius.circular(5),
        child: Center(
          child: image == null
              ? Text(
                  keyModel.label,
                  style: AppTextStyle.textStyleButton.copyWith(
                    color: fontColor,
                  ),
                )
              : Image.asset(
                  image!,
                  color: fontColor,
                ),
        ),
      ),
    );
  }
}
