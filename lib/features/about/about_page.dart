import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/themes/styles/app_text_styles.dart';
import 'about_page_controller.dart';
import 'about_page_state.dart';

const pageUrl = 'https://jrblog.com.br/labcalc2/';
const email = 'alvesdev67@gmail.com';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  static const routeName = '/about';

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _aboutController = AboutPageController();

  @override
  void initState() {
    super.initState();
    _aboutController.init();
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

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
      body: ListenableBuilder(
        listenable: _aboutController,
        builder: (context, _) {
          if (_aboutController.state is AboutPageStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (_aboutController.state is AboutPageStateSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    _aboutController.packageInfo.appName,
                    style: AppTextStyle.textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Version: ${_aboutController.packageInfo.version}',
                    style: AppTextStyle.textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const Text(
                    'Application developed by Rudson R Alves',
                    style: AppTextStyle.textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: _launchMailto,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 6),
                        Text(
                          email,
                          style: AppTextStyle.textStyleTitle,
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
                  TextButton(
                    onPressed: _lauchUrl,
                    child: const Text(
                      pageUrl,
                      style: AppTextStyle.textStyleTitle,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Error...'),
            );
          }
        },
      ),
    );
  }
}
