import 'package:flutter/material.dart';

import '../../../../common/constants/constants.dart';

class StatusBarWidget extends StatefulWidget {
  final int fix;
  final bool isRadians;
  final bool truncate;
  final TypeMean mean;
  final TypeDeviation deviation;

  const StatusBarWidget({
    super.key,
    required this.fix,
    required this.isRadians,
    required this.truncate,
    required this.mean,
    required this.deviation,
  });

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Text(
          'Fix: ${widget.fix == -1 ? 'off' : '${widget.fix}'}'
          '    ${widget.isRadians ? 'RAD' : 'DEG'}'
          '    Trunc: ${widget.truncate ? 'on' : 'off'}'
          '    Mean: ${meanSignature[widget.mean]} ±'
          ' ${deviationSignature[widget.deviation]}'
          ' (n = 0)',
        ),
      ),
    );
  }
}
