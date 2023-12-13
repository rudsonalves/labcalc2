import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/themes/styles/app_text_styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final appSettings = AppSettings.instance;

  void _changeTypeMean(TypeMean? value) {
    if (value != null) {
      appSettings.mean = value;
    }
  }

  void _changeTypeDeviation(TypeDeviation? value) {
    if (value != null) {
      appSettings.deviation = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mean Method',
              style: AppTextStyle.textStyleTitle,
            ),
            ListenableBuilder(
              listenable: appSettings.mean$,
              builder: (context, child) => Column(
                children: [
                  RadioListTile<TypeMean>(
                    title: const Text('Arithmetic Mean'),
                    value: TypeMean.arithmetic,
                    groupValue: appSettings.mean,
                    onChanged: _changeTypeMean,
                  ),
                  RadioListTile<TypeMean>(
                    title: const Text('Harmonic Mean'),
                    value: TypeMean.harmonic,
                    groupValue: appSettings.mean,
                    onChanged: _changeTypeMean,
                  ),
                  RadioListTile<TypeMean>(
                    title: const Text('Root Mean Square'),
                    value: TypeMean.rms,
                    groupValue: appSettings.mean,
                    onChanged: _changeTypeMean,
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text(
              'Mean Deviations',
              style: AppTextStyle.textStyleTitle,
            ),
            ListenableBuilder(
              listenable: appSettings.deviation$,
              builder: (context, child) => Column(
                children: [
                  RadioListTile<TypeDeviation>(
                    title: const Text('Simple Mean Deviation'),
                    value: TypeDeviation.meanDeviation,
                    groupValue: appSettings.deviation,
                    onChanged: _changeTypeDeviation,
                  ),
                  RadioListTile<TypeDeviation>(
                    title: const Text('Sampling Standard Deviation'),
                    value: TypeDeviation.sampleStdDeviation,
                    groupValue: appSettings.deviation,
                    onChanged: _changeTypeDeviation,
                  ),
                  RadioListTile<TypeDeviation>(
                    title: const Text('Population Standard Deviation'),
                    value: TypeDeviation.popStdDeviation,
                    groupValue: appSettings.deviation,
                    onChanged: _changeTypeDeviation,
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text(
              'Others Configurations',
              style: AppTextStyle.textStyleTitle,
            ),
            ListenableBuilder(
              listenable: appSettings.isRadians$,
              builder: (context, child) => CheckboxListTile(
                title: const Text('Trigonometry functions in radians mode'),
                controlAffinity: ListTileControlAffinity.leading,
                value: appSettings.isRadians,
                onChanged: (value) => appSettings.toggleIsRadians(),
              ),
            ),
            ListenableBuilder(
              listenable: appSettings.truncate$,
              builder: (context, child) => CheckboxListTile(
                title: const Text('Enable Measure truncate'),
                controlAffinity: ListTileControlAffinity.leading,
                value: appSettings.truncate,
                onChanged: (value) => appSettings.toggleTruncate(),
              ),
            ),
            ListenableBuilder(
              listenable: appSettings.fix$,
              builder: (context, child) => Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Fix value:',
                      style: AppTextStyle.textStyleNormal,
                    ),
                    IconButton(
                      onPressed: appSettings.decrementFix,
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      appSettings.fix.toString(),
                      style: AppTextStyle.textStyleMedium,
                    ),
                    IconButton(
                      onPressed: appSettings.incrementFix,
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ),
            ListenableBuilder(
              listenable: appSettings.themeMode$,
              builder: (context, child) => Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Theme Mode: ',
                      style: AppTextStyle.textStyleNormal,
                    ),
                    IconButton(
                      onPressed: appSettings.toggleThemeMode,
                      icon: Icon(appSettings.themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : appSettings.themeMode == ThemeMode.light
                              ? Icons.light_mode
                              : Icons.android),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
