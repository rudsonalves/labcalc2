import 'package:flutter/material.dart';

import '../../common/themes/styles/app_text_styles.dart';
import '../about/about_page.dart';
import '../settings/settings_page.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  static const routeName = '/calculator';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.pop(context);
            Navigator.pushNamed(context, SettingsPage.routeName);
          } else if (index == 1) {
            Navigator.pop(context);
            Navigator.pushNamed(context, AboutPage.routeName);
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
          )
        ],
      ),
      appBar: AppBar(
        title: const Text('Laboratory Calculator'),
        elevation: 10,
      ),
      body: const Center(child: Text('Calculator Page...')),
    );
  }
}
