import 'package:flutter/material.dart';

import '../../../../common/constants/constants.dart';

class StatusBarWidget extends StatelessWidget {
  final int fix;
  final bool isRadians;
  final bool truncate;
  final TypeMean mean;
  final TypeDeviation deviation;
  final int counter;

  const StatusBarWidget({
    super.key,
    required this.fix,
    required this.isRadians,
    required this.truncate,
    required this.mean,
    required this.deviation,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          'Fix: ${fix == -1 ? 'off' : '$fix'}'
          '    ${isRadians ? 'rad' : 'deg'}'
          '    Trunc: ${truncate ? 'on' : 'off'}'
          '    Mean: ${meanSignature[mean]} ±'
          ' ${deviationSignature[deviation]}'
          ' (n = $counter})',
        ),
      ),
    );
  }
}
