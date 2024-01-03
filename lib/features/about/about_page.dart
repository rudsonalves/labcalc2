import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants/app_info.dart';
import '../../common/themes/colors/app_colors.dart';
import '../../common/themes/styles/app_text_styles.dart';

const pageUrl = 'https://jrblog.com.br/labcalc2/';
const email = 'alvesdev67@gmail.com';
const privacyPolicyUrl = 'https://jrblog.com.br/privacy-policy-for-tuxdev67/';
const double height = 30;

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const routeName = '/about';

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  void _copyUrl(String url) async {
    // final uri = Uri.parse(url);

    // copy link to clipboard
    await Clipboard.setData(ClipboardData(text: url));

    // open link in browser
    // if (await canLaunchUrl(uri)) {
    //   await launchUrl(uri);
    // } else {
    //   debugPrint("URL can't be launched.");
    // }

    // Timer _time =  Timer.periodic(
    //   const Duration(seconds: 2),
    //   (timer) {
    //     if (value < maxValue) {
    //       _increment();
    //     } else {
    //       _incrementTimer?.cancel();
    //     }
    //   },
    // );
  }

  void _launchMailto() async {
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
                    onPressed: () => _copyUrl(pageUrl),
                    child: Text(
                      pageUrl,
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
                    onPressed: () => _copyUrl(privacyPolicyUrl),
                    child: Text(
                      privacyPolicyUrl.replaceAll('icy-for-tuxdev67', '...'),
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
