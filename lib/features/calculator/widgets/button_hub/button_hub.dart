import 'package:flutter/material.dart';

import '../../../../common/singletons/app_settings.dart';
import '../../../../common/themes/colors/app_colors.dart';
import 'calc_button.dart';

class ButtonHub extends StatefulWidget {
  const ButtonHub({super.key});

  @override
  State<ButtonHub> createState() => _ButtonHubState();
}

class _ButtonHubState extends State<ButtonHub> {
  final _app = AppSettings.instance;

  void printButton(value) {
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 5;
        double totalHorizontalPadding = 16 + (crossAxisCount - 1) * 5;
        double buttonWidth =
            (constraints.maxWidth - totalHorizontalPadding) / crossAxisCount;

        int totalButtons = 50;
        int totalRows = (totalButtons / crossAxisCount).ceil();
        double totalVerticalPadding = 8 + (totalRows - 1) * 5;
        double availableHeight = constraints.maxHeight - totalVerticalPadding;
        double buttonHeight = availableHeight / totalRows;

        return GridView.count(
          primary: false,
          padding: const EdgeInsets.all(8),
          crossAxisSpacing: crossAxisCount.toDouble(),
          mainAxisSpacing: 5,
          crossAxisCount: 5,
          childAspectRatio: buttonWidth / buttonHeight,
          children: [
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: '2nd',
                    // image: 'assets/images/buttons/2nd.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: !_app.secondFunc
                        ? AppColors.buttonSecondFunc
                        : AppColors.buttonSecondFunc.shade900,
                    buttonCallBack: (_) => _app.toggleSecondFunc(),
                  );
                }),
            CalcButton(
              label: '◀',
              buttonColor: AppColors.buttonDirectional,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '▲',
              buttonColor: AppColors.buttonDirectional,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '▼',
              buttonColor: AppColors.buttonDirectional,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '▶',
              buttonColor: AppColors.buttonDirectional,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: 'STO',
              // image: 'assets/images/buttons/sto.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMemories,
              buttonCallBack: printButton,
            ),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'A' : 'E',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: AppColors.buttonFunctions,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'B' : 'F',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: AppColors.buttonFunctions,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'C' : 'G',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: AppColors.buttonFunctions,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'D' : 'H',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: AppColors.buttonFunctions,
                    buttonCallBack: printButton,
                  );
                }),
            CalcButton(
              label: 'x±𝛅x',
              image: 'assets/images/buttons/measure.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '±',
              image: 'assets/images/buttons/pm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: AppColors.buttonMeasures,
              buttonCallBack: printButton,
            ),
            ListenableBuilder(
                listenable: _app.truncate$,
                builder: (context, _) {
                  return CalcButton(
                    label: '~',
                    image: 'assets/images/buttons/trunc.png',
                    fontColor: AppColors.fontWhite,
                    buttonColor: !_app.truncate
                        ? AppColors.buttonMeasures
                        : AppColors.buttonMeasures.shade900,
                    buttonCallBack: (_) => _app.toggleTruncate(),
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? '𝚺x' : 'Rst',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/sumx.png'
                        : null,
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonColor: const Color(0xFF3DD3F8),
                    buttonCallBack: printButton,
                  );
                }),
            CalcButton(
              label: 'xm',
              image: 'assets/images/buttons/xm.png',
              fontColor: AppColors.fontWhite,
              buttonColor: const Color(0xFF3DD3F8),
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: 'Abs',
              image: 'assets/images/buttons/abs.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'ln' : 'e^x',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/ln.png'
                        : 'assets/images/buttons/ex.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'log' : '10^x',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/log.png'
                        : 'assets/images/buttons/tenx.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            CalcButton(
              label: '( - )',
              image: 'assets/images/buttons/minusset.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: 'π',
              image: 'assets/images/buttons/pi.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            ListenableBuilder(
                listenable: _app.isRadians$,
                builder: (context, _) {
                  return CalcButton(
                    label: _app.isRadians ? 'rad' : 'deg',
                    image: _app.isRadians
                        ? 'assets/images/buttons/rad.png'
                        : 'assets/images/buttons/deg.png',
                    fontColor: _app.isRadians
                        ? AppColors.fontWhite
                        : AppColors.fontGreen,
                    buttonCallBack: (_) => _app.toggleIsRadians(),
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'sin' : 'asin',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/sin.png'
                        : 'assets/images/buttons/sininv.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'cos' : 'acos',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/cos.png'
                        : 'assets/images/buttons/cosinv.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'tan' : 'atan',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/tan.png'
                        : 'assets/images/buttons/taninv.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            CalcButton(
              label: 'Fix',
              image: 'assets/images/buttons/fix.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'x²' : 'x^1/2',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/x2.png'
                        : 'assets/images/buttons/sqr.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'x³' : 'x^1/3',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/x3.png'
                        : 'assets/images/buttons/sqr3.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            ListenableBuilder(
                listenable: _app.secondFunc$,
                builder: (context, _) {
                  return CalcButton(
                    label: !_app.secondFunc ? 'x^y' : 'x^1/y',
                    image: !_app.secondFunc
                        ? 'assets/images/buttons/xy.png'
                        : 'assets/images/buttons/sqry.png',
                    fontColor: !_app.secondFunc
                        ? AppColors.fontWhite
                        : AppColors.fontYellow,
                    buttonCallBack: printButton,
                  );
                }),
            CalcButton(
              label: '(',
              image: 'assets/images/buttons/open.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: ')',
              image: 'assets/images/buttons/close.png',
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '7',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '8',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '9',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: 'BS',
              // image: 'assets/images/buttons/bs.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: 'CLR',
              // image: 'assets/images/buttons/clr.png',
              buttonColor: AppColors.buttonClean,
              fontColor: AppColors.fontWhite,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '4',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '5',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '6',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '*',
              image: 'assets/images/buttons/times.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '/',
              image: 'assets/images/buttons/div.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '1',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '2',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '3',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '+',
              image: 'assets/images/buttons/plus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '-',
              image: 'assets/images/buttons/minus.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '0',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '.',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: 'EE',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: 'ANS',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
            CalcButton(
              label: '=',
              image: 'assets/images/buttons/eq.png',
              buttonColor: AppColors.buttonBasics,
              buttonCallBack: printButton,
            ),
          ],
        );
      },
    );
  }
}
