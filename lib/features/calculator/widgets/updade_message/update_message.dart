import 'package:flutter/material.dart';

import '../../../../common/constants/app_info.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/themes/styles/app_button_styles.dart';

void updateMessage(BuildContext context) {
  final app = AppSettings.instance;

  if (app.version != AppInfo.version) {
    bool checkBox = false;
    final String oldVersion = app.version;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, StateSetter setState) {
          return AlertDialog(
            title: const Text('News in ${AppInfo.version}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'This version of LabCalc introduces key adjustments in'
                    ' branding, accessibility improvements, and optimizations for'
                    ' testing. The changes include:'),
                CheckboxListTile(
                  value: checkBox,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.darkPrimary,
                  subtitle: const Text('Don\'t show this message again'),
                  onChanged: (value) {
                    setState(() {
                      checkBox = value ?? checkBox;
                      app.version = checkBox ? AppInfo.version : oldVersion;
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: AppButtonStyles.primaryButton(context),
                child: const Text('Close'),
              )
            ],
          );
        },
      ),
    );
  }
}
