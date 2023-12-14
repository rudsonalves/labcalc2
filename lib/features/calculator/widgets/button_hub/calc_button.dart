import 'package:flutter/material.dart';

import '../../../../common/themes/styles/app_text_styles.dart';

class CalcButton extends StatelessWidget {
  final String label;
  final String? image;
  final Color buttonColor;
  final Color fontColor;
  final void Function(String value) buttonCallBack;

  const CalcButton({
    super.key,
    required this.label,
    this.image,
    this.buttonColor = Colors.grey,
    this.fontColor = Colors.black,
    required this.buttonCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () => buttonCallBack(label),
        // splashColor: Colors.grey[30],
        borderRadius: BorderRadius.circular(5),
        child: Center(
          child: image == null
              ? Text(
                  label,
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
