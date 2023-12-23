import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

import '../../../../common/models/display/display_controller.dart';
import '../../../../common/models/measure/statistic.dart';
import '../../../../common/models/memories/app_memories.dart';
import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import '../../../../common/themes/styles/app_button_styles.dart';
import '../../../../common/themes/styles/app_text_styles.dart';

class ResetButton extends StatefulWidget {
  const ResetButton({super.key});

  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  Timer? _timer;
  final _countdown = ValueNotifier<int>(5);
  final int animationDelayMill = 200;
  final int animationSec = 10;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stratTimer() {
    _timer = Timer.periodic(
      Duration(milliseconds: animationDelayMill),
      (timer) {
        if (_countdown.value > 0) {
          _countdown.value--;
        } else {
          timer.cancel();
          _resetCalculator();
          Future.delayed(
            Duration(milliseconds: animationDelayMill),
            () => Navigator.of(context).pop(),
          );
        }
      },
    );
  }

  void _resetCalculator() {
    DisplayController.instance.resetDisplay();
    AppMemories.instante.resetMemories();
    StatisticController.instance.clear();
    AppSettings.instance.reset();
  }

  void _cancelResetTimer() {
    // Cancels the timer if it is still active
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  void _showResetDialog() {
    int animationSteps = (1000 * animationSec) ~/ animationDelayMill;
    _countdown.value = animationSteps;

    _stratTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset LabCalc'),
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: ListenableBuilder(
                  listenable: _countdown,
                  builder: (context, _) {
                    double progress = _countdown.value / animationSteps;
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
                  if (_timer?.isActive ?? false) {
                    _cancelResetTimer();
                    Future.delayed(
                      Duration(milliseconds: animationDelayMill),
                      () => Navigator.of(context).pop(),
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
    ).then((_) => _cancelResetTimer());
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: AppColors.buttonReset,
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: _showResetDialog,
        splashColor: AppColors.buttonReset.lighter(20),
        borderRadius: BorderRadius.circular(5),
        child: const Center(
          child: Icon(
            Icons.refresh_outlined,
            color: AppColors.fontWhite,
          ),
        ),
      ),
    );
  }
}
