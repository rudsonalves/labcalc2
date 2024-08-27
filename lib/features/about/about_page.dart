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

import '../../common/constants/app_info.dart';
import '../../common/themes/colors/app_colors.dart';
import '../../common/themes/styles/app_text_styles.dart';

const double height = 30;

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const routeName = '/about';

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String simpleAddress(String address) {
    return address.replaceFirst('https://', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: height),
            Text(
              'LabCalc',
              style: AppTextStyle.textStyleBig.copyWith(fontSize: 44),
              textAlign: TextAlign.center,
            ),
            Text(
              'Version: ${AppInfo.version}',
              style: AppTextStyle.textStyleTitle.copyWith(
                color: AppColors.darkPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: height * 2),
            const Text(
              'Application developed by',
              style: AppTextStyle.textStyleTitle,
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => AppInfo.launchMailto(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.email,
                    color: AppColors.darkPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppInfo.email,
                    style: AppTextStyle.textStyleTitle.copyWith(
                      color: AppColors.darkPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: height),
            const Text(
              'LabCalc Mathematical base',
              style: AppTextStyle.textStyleTitle,
              textAlign: TextAlign.center,
            ),
            Tooltip(
              message: 'Click to copy the link to the clikboard',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.public,
                    color: AppColors.darkPrimary,
                  ),
                  const SizedBox(width: 6),
                  TextButton(
                    onPressed: () => AppInfo.launchUrl(AppInfo.pageUrl),
                    child: Text(
                      simpleAddress(AppInfo.pageUrl),
                      style: AppTextStyle.textStyleTitle.copyWith(
                        color: AppColors.darkPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: height),
            const Text(
              'Privacy Policy',
              style: AppTextStyle.textStyleTitle,
              textAlign: TextAlign.center,
            ),
            Tooltip(
              message: 'Click to copy the link to the clikboard',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.public,
                    color: AppColors.darkPrimary,
                  ),
                  const SizedBox(width: 6),
                  TextButton(
                    onPressed: () =>
                        AppInfo.launchUrl(AppInfo.privacyPolicyUrl),
                    child: Text(
                      simpleAddress(AppInfo.privacyPolicyUrl
                          .replaceAll('com.br/', 'com.br/\n')),
                      style: AppTextStyle.textStyleTitle.copyWith(
                        color: AppColors.darkPrimary,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: height),
          ],
        ),
      ),
    );
  }
}
