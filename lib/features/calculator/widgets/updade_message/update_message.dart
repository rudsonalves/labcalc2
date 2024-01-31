import 'package:flutter/material.dart';

import '../../../../common/constants/app_info.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/themes/styles/app_button_styles.dart';

const message = '''
In addition to some technical improvements and usability adjustments, in this version: a change to the application's data storage approach was implemented, improving overall stability and security; addition of the About page for general information such as version, developer contact and project page; our Privacy Policy has been updated.

To find out more details, access the page using the button below or through the About page.
''';

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
                const Text(message),
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
                onPressed: () => AppInfo.launchUrl(AppInfo.privacyPolicyUrl),
                style: AppButtonStyles.primaryButton(context),
                child: const Text('Privacy Policy (en)'),
              ),
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
