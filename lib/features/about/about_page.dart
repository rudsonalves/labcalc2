import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants/app_info.dart';
import '../../common/themes/colors/app_colors.dart';
import '../../common/themes/styles/app_text_styles.dart';

const pageUrl = 'https://jrblog.com.br/labcalc2/';
const email = 'alvesdev67@gmail.com';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const routeName = '/about';

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _lauchUrl() async {
    const url = pageUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("URL can't be launched.");
    }
  }

  _launchMailto() async {
    Uri url = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': '[LabCalc] - <Your Subject text>'},
    );
    await launchUrl(url);
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
            const Spacer(),
            const Text(
              AppInfo.name,
              style: AppTextStyle.textStyleTitle,
              textAlign: TextAlign.center,
            ),
            Text(
              'Version: ${AppInfo.version}',
              style: AppTextStyle.textStyleTitle.copyWith(
                color: AppColors.darkPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const Text(
              'Application developed by',
              style: AppTextStyle.textStyleTitle,
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: _launchMailto,
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
                    email,
                    style: AppTextStyle.textStyleTitle.copyWith(
                      color: AppColors.darkPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text(
              'LabCalc Mathematical base',
              style: AppTextStyle.textStyleTitle,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.public,
                  color: AppColors.darkPrimary,
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: _lauchUrl,
                  child: Text(
                    pageUrl,
                    style: AppTextStyle.textStyleTitle.copyWith(
                      color: AppColors.darkPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
