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
            () {
              if (context.mounted) {
                DialogReset.execute(context);
              }
            },
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
