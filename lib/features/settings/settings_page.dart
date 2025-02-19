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

import '../../common/constants/constants.dart';
import '../../common/singletons/app_settings.dart';
import '../../common/themes/colors/app_colors.dart';
import '../../common/themes/styles/app_text_styles.dart';
import '../../common/widgets/fix_spin_button.dart';

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
        elevation: 5,
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
                    activeColor: AppColors.darkPrimary,
                    title: const Text('Arithmetic Mean'),
                    value: TypeMean.arithmetic,
                    groupValue: appSettings.mean,
                    onChanged: _changeTypeMean,
                  ),
                  RadioListTile<TypeMean>(
                    activeColor: AppColors.darkPrimary,
                    title: const Text('Harmonic Mean'),
                    value: TypeMean.harmonic,
                    groupValue: appSettings.mean,
                    onChanged: _changeTypeMean,
                  ),
                  RadioListTile<TypeMean>(
                    activeColor: AppColors.darkPrimary,
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
                    activeColor: AppColors.darkPrimary,
                    title: const Text('Simple Mean Deviation'),
                    value: TypeDeviation.meanDeviation,
                    groupValue: appSettings.deviation,
                    onChanged: _changeTypeDeviation,
                  ),
                  RadioListTile<TypeDeviation>(
                    activeColor: AppColors.darkPrimary,
                    title: const Text('Sampling Standard Deviation'),
                    value: TypeDeviation.sampleStdDeviation,
                    groupValue: appSettings.deviation,
                    onChanged: _changeTypeDeviation,
                  ),
                  RadioListTile<TypeDeviation>(
                    activeColor: AppColors.darkPrimary,
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
                activeColor: AppColors.darkPrimary,
                title: const Text('Trigonometry functions in radians mode'),
                controlAffinity: ListTileControlAffinity.leading,
                value: appSettings.isRadians,
                onChanged: (value) => appSettings.toggleIsRadians(),
              ),
            ),
            ListenableBuilder(
              listenable: appSettings.truncate$,
              builder: (context, child) => CheckboxListTile(
                activeColor: AppColors.darkPrimary,
                title: const Text('Enable Measure truncate'),
                controlAffinity: ListTileControlAffinity.leading,
                value: appSettings.truncate,
                onChanged: (value) => appSettings.toggleTruncate(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 32),
              child: FixSpinButton(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
