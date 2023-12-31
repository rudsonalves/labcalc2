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
                    'Welcome to LabCalc2, an innovative and powerful Scientific'
                    ' Calculator designed to meet the needs of professionals'
                    ' and students in the fields of science and engineering.'
                    '\n\nLabCalc2 is not just a calculation tool; it\'s an'
                    ' advanced platform for accurate and reliable uncertainty'
                    ' analysis.\n\n'),
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
