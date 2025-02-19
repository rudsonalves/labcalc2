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

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../common/models/display/display_controller.dart';
import '../../../../common/models/measure/statistic.dart';
import '../../../../common/models/memories/app_memories.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/styles/app_button_styles.dart';
import '../../../../common/themes/styles/app_text_styles.dart';

class DialogReset {
  DialogReset._();

  static const int animationDelayMillisecond = 200;
  static const int animationSec = 5;

  static void execute(BuildContext context) {
    int animationSteps = (1000 * animationSec) ~/ animationDelayMillisecond;
    ValueNotifier<int> countdown = ValueNotifier<int>(animationSteps);

    Timer? timer;

    void cancelResetTimer() {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
    }

    void resetCalculator() {
      cancelResetTimer();

      DisplayController.instance.resetDisplay();
      AppMemories.instante.resetMemories();
      StatisticController.instance.clear();
      AppSettings.instance.reset();
    }

    void startTimer(BuildContext context) {
      timer = Timer.periodic(
        const Duration(milliseconds: animationDelayMillisecond),
        (Timer timer) {
          if (countdown.value > 0) {
            countdown.value--;
          } else {
            resetCalculator();
            Future.delayed(
              const Duration(milliseconds: animationDelayMillisecond),
              () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            );
          }
        },
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        startTimer(context);

        return AlertDialog(
          title: const Text('Reset LabCalc'),
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ListenableBuilder(
                  listenable: countdown,
                  builder: (context, _) {
                    double progress = countdown.value / animationSteps;
                    int restTime = 1 + (animationSec * progress).toInt();
                    restTime =
                        restTime < animationSec ? restTime : animationSec;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Your calculator will be reset in',
                          style: AppTextStyle.textStyleMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: CircularProgressIndicator(
                                  semanticsValue: restTime.toString(),
                                  value: progress,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                ),
                              ),
                              Text(
                                '${restTime}s',
                                style: AppTextStyle.textStyleBold,
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (timer?.isActive ?? false) {
                    cancelResetTimer();
                    Future.delayed(
                      const Duration(milliseconds: animationDelayMillisecond),
                      () {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  }
                },
                style: AppButtonStyles.primaryButton(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        );
      },
    ).then((_) => cancelResetTimer());
  }
}
