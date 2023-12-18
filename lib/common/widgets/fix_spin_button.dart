import 'package:flutter/material.dart';

import '../singletons/app_settings.dart';
import '../themes/styles/app_text_styles.dart';

class FixSpinButton extends StatelessWidget {
  const FixSpinButton({
    super.key,
    required this.appSettings,
  });

  final AppSettings appSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        ListenableBuilder(
            listenable: appSettings.fix$,
            builder: (context, _) {
              return Text(
                appSettings.fix.toString(),
                style: AppTextStyle.textStyleMedium,
              );
            }),
        IconButton(
          onPressed: appSettings.incrementFix,
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
