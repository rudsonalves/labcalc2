import 'package:flutter/material.dart';

import '../../../common/themes/styles/app_text_styles.dart';
import '../../about/about_page.dart';
import '../../settings/settings_page.dart';
import 'dialog_reset/dialog_reset.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (index) {
        if (index == 0) {
          Navigator.pop(context);
          Navigator.pushNamed(context, SettingsPage.routeName);
        } else if (index == 1) {
          Navigator.pop(context);
          Navigator.pushNamed(context, AboutPage.routeName);
        } else if (index == 2) {
          Navigator.pop(context);
          Future.delayed(
            Duration.zero,
            () => DialogReset.execute(context),
          );
        }
      },
      children: const [
        NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text(
            'Settings',
            style: AppTextStyle.textStyleNormal,
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.person),
          label: Text(
            'About',
            style: AppTextStyle.textStyleNormal,
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.restart_alt_outlined),
          label: Text(
            'Reset Calculator',
            style: AppTextStyle.textStyleNormal,
          ),
        ),
      ],
    );
  }
}
