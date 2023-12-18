import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:labcalc2/common/constants/constants.dart';
import 'package:labcalc2/common/models/measure/measure.dart';
import 'package:labcalc2/common/models/measure/measure_functions.dart';
import 'package:labcalc2/common/singletons/app_settings.dart';

void main() {
  group('Statistics Functions:', () {
    test('arithmeticMean', () {
      expect(arithmeticMean(<double>[10, 11, 12, 13, 15]), 12.2);
      expect(arithmeticMean(<double>[10.5, 11.5, 12.5, 13.5, 15.5]), 12.7);
    });

    test('harmonicMean', () {
      expect(harmonicMean(<double>[10, 11, 12, 13, 15]), 11.96652719665272);
    });

    test('rmsMean', () {
      expect(rmsMean(<double>[10, 11, 12, 13, 15]), 12.320714265009151);
    });

    test('simpleMeaDeviation', () {
      expect(
        simpleMeaDeviation(<double>[10, 11, 12, 13, 15], 12.2),
        1.44,
      );
    });

    test('sampleStandardDeviation', () {
      expect(
        sampleStandardDeviation(<double>[10, 11, 12, 13, 15], 12.2),
        0.9617692030835673,
      );
    });

    test('popsStandardDeviation', () {
      expect(
        popsStandardDeviation(<double>[10, 11, 12, 13, 15], 12.2),
        0.7694153624668538,
      );
    });

    test('sumAll', () {
      expect(sumAll(<double>[10, 11, 12, 13, 15]), 61);
    });
  });

  group('Measure statistic Mean:', () {
    setUp(() {
      AppSettings.instance.reset();
    });

    test('calculateXm arithmetic ± meanDeviation;', () {
      Measure result = calculateXm([10, 11, 12, 15]);
      expect(result, Measure(12.0, 1.5));

      result = calculateXm([1.2, 1.6, 1.4, 1.5]);
      expect(result, Measure(1.4249999999999998, 0.12500000000000006));
    });

    test('calculateXm harmonic ± sampleStdDeviation;', () {
      AppSettings.instance.mean = TypeMean.harmonic;
      AppSettings.instance.deviation = TypeDeviation.sampleStdDeviation;

      Measure result = calculateXm([10, 11, 12, 15]);
      expect(result, Measure(11.733333333333334, 1.259825580716299));

      result = calculateXm([1.2, 1.6, 1.4, 1.5]);
      expect(result, Measure(1.4088050314465408, 0.09919067385920592));
    });

    test('calculateXm rms ± popStdDeviation;', () {
      AppSettings.instance.mean = TypeMean.rms;
      AppSettings.instance.deviation = TypeDeviation.popStdDeviation;

      Measure result = calculateXm([10, 11, 12, 15]);
      expect(result, Measure(12.144957801491119, 0.9382180935439717));

      result = calculateXm([1.2, 1.6, 1.4, 1.5]);
      expect(result, Measure(1.4326548781894404, 0.07404997832561327));
    });
  });

  group('Measures Functions:', () {
    test('measureAbs', () {
      expect(measureAbs(Measure(-2.32, .23)), Measure(2.32, .23));
      expect(measureAbs(Measure(2.32, .23)), Measure(2.32, .23));
    });

    test('measurePow', () {
      expect(measurePow(Measure(2.32, .03), 2), Measure(5.3824, 0.1392));
      expect(measurePow(Measure(2.32, .03), 3),
          Measure(12.487167999999999, 0.484416));
    });

    test('measureSqrt', () {
      expect(measureSqrt(Measure(2.32, .03)),
          Measure(1.5231546211727816, 0.009847982464479191));
    });

    test('measureFunction', () {
      expect(measureFunction(Measure(2.32, .03), math.sin),
          Measure(0.7319019645925077, 0.020428611801663));

      expect(measureFunction(Measure(2.32, .03), math.log),
          Measure(0.8414835728611079, 0.012931755294959602));
    });

    test('measureLn', () {
      expect(measureLn(Measure(12.5, .8)),
          Measure(2.523676438515709, 0.06408759671199893));
    });

    test('measureLog', () {
      expect(measureLog(Measure(12.5, .8)),
          Measure(1.0960187513566235, 0.027832889610462153));
    });

    test('measureExp', () {
      expect(measureExp(Measure(2.35, .03)),
          Measure(10.490288585002297, 0.31461427892895966));
    });

    test('measurePow10', () {
      expect(measurePow10(Measure(2.35, .03)),
          Measure(224.4064524936765, 15.476839408272454));
    });
  });

  group('Numerics Functions:', () {
    test('abs', () {
      expect(abs(2.35), 2.35);

      expect(abs(-2.35), 2.35);
    });

    test('numAdd', () {
      expect(numAdd(2, 5), 7);

      expect(
          numAdd(Measure(2.35, .05), Measure(3.28, .03)), Measure(5.63, .08));

      expect(
          numAdd(Measure(3.28, .03), Measure(2.35, .05)), Measure(5.63, .08));

      expect(() => numAdd(2, Measure(2.35, .05)),
          throwsA(isA<OperationNotAllowed>()));

      expect(() => numAdd(Measure(2.35, .05), 2),
          throwsA(isA<OperationNotAllowed>()));
    });

    test('numSub', () {
      expect(numSub(2, 5), -3);

      expect(numSub(Measure(2.35, .05), Measure(3.28, .03)),
          Measure(-0.9299999999999997, .08));

      expect(numSub(Measure(3.28, .03), Measure(2.35, .05)),
          Measure(0.9299999999999997, .08));

      expect(() => numSub(2, Measure(2.35, .05)),
          throwsA(isA<OperationNotAllowed>()));

      expect(() => numSub(Measure(2.35, .05), 2),
          throwsA(isA<OperationNotAllowed>()));
    });

    test('numMult', () {
      expect(numMult(2, 5), 10);

      expect(numMult(Measure(2.35, .05), Measure(3.28, .03)),
          Measure(7.708, 0.2345));

      expect(numMult(Measure(3.28, .03), Measure(2.35, .05)),
          Measure(7.708, 0.2345));

      expect(numMult(2, Measure(2.35, .05)), Measure(4.7, .1));

      expect(numMult(Measure(2.35, .05), 2), Measure(4.7, .1));

      expect(() => numMult('2', Measure(2.35, .05)),
          throwsA(isA<OperationNotAllowed>()));

      expect(() => numMult(Measure(2.35, .05), '2'),
          throwsA(isA<OperationNotAllowed>()));
    });

    test('numDiv', () {
      expect(numDiv(2, 5), .4);

      expect(numDiv(Measure(2.35, .05), Measure(3.28, .03)),
          Measure(0.7164634146341464, 0.021796921475312314));

      expect(numDiv(Measure(3.28, .03), Measure(2.35, .05)),
          Measure(1.3957446808510636, 0.04246265278406518));

      expect(numDiv(2, Measure(2.35, .05)),
          Measure(0.851063829787234, 0.018107741059302854));

      expect(numDiv(Measure(2.35, .05), 2), Measure(1.175, 0.025));

      expect(() => numDiv('2', Measure(2.35, .05)),
          throwsA(isA<OperationNotAllowed>()));

      expect(() => numDiv(Measure(2.35, .05), '2'),
          throwsA(isA<OperationNotAllowed>()));
    });

    test('numAbs', () {
      expect(numAbs(5), 5);

      expect(numAbs(-5), 5);

      expect(numAbs(Measure(2.35, .05)), Measure(2.35, .05));

      expect(numAbs(Measure(-2.35, .05)), Measure(2.35, .05));

      expect(() => numAbs('Measure(-2.35, .05)'),
          throwsA(isA<OperationNotAllowed>()));
    });

    test('numLn', () {
      expect(numLn(5), 1.6094379124341003);

      expect(numLn(Measure(12.5, .8)),
          Measure(2.523676438515709, 0.06408759671199893));

      expect(() => numLn('2'), throwsA(isA<OperationNotAllowed>()));
    });

    test('numLog', () {
      expect(numLog(5), 0.6989700043360187);

      expect(numLog(Measure(12.5, .8)),
          Measure(1.0960187513566235, 0.027832889610462153));

      expect(() => numLog('2'), throwsA(isA<OperationNotAllowed>()));
    });

    test('numPow', () {
      expect(numPow(5, 3), 125);

      expect(numPow(Measure(1.25, .06), 3), Measure(1.953125, 0.28125));

      expect(() => numPow('2', 3), throwsA(isA<OperationNotAllowed>()));
    });

    test('numPowi', () {
      expect(numPowi(5, 3), 1.7099759466766968);

      expect(numPowi(Measure(82.5, .6), 3),
          Measure(4.353293845586806, 0.010553439625664985));

      expect(() => numPowi('2', 3), throwsA(isA<OperationNotAllowed>()));
    });

    test('numPow2', () {
      expect(numPow2(5), 25);

      expect(numPow2(Measure(1.825, .006)),
          Measure(3.330625, 0.021900000000000003));

      expect(() => numPow2('2'), throwsA(isA<OperationNotAllowed>()));
    });

    test('numPow3', () {
      expect(numPow3(5), 125);

      expect(numPow3(Measure(1.825, .006)), Measure(6.078390625, 0.05995125));

      expect(() => numPow3('2'), throwsA(isA<OperationNotAllowed>()));
    });

    test('numPowi3', () {
      expect(numPowi3(5), 1.7099759466766968);

      expect(numPowi3(Measure(82.5, .6)),
          Measure(4.353293845586806, 0.010553439625664985));

      expect(() => numPowi3('2'), throwsA(isA<OperationNotAllowed>()));
    });

    test('numPow10', () {
      expect(numPow10(5), 100000);

      expect(numPow10(Measure(1.825, .006)),
          Measure(66.84077014274982, 0.9233806183176867));

      expect(() => numPow10('2'), throwsA(isA<OperationNotAllowed>()));
    });

    test('numExp', () {
      expect(numExp(5), 148.4131591025766);

      expect(numExp(Measure(1.825, .006)),
          Measure(6.20290666975016, 0.03721699341565188));

      expect(() => numExp('2'), throwsA(isA<OperationNotAllowed>()));
    });

    test('numSqrt', () {
      expect(numSqrt(5), 2.23606797749979);

      expect(numSqrt(Measure(2.32, .03)),
          Measure(1.5231546211727816, 0.009847982464479191));

      expect(() => numSqrt('2'), throwsA(isA<OperationNotAllowed>()));
    });
  });

  group('Meassure Trigonometric Functions:', () {
    test('measureSin', () {
      expect(measureSin(Measure(2.32, .03)),
          Measure(0.7319019645925077, 0.020428611801663));

      expect(measureSin(Measure(1.59, 0.06)),
          Measure(0.9984325142269594, 0.0015674857730405556));

      expect(measureSin(Measure(1.55, 0.06)),
          Measure(0.9983688760215716, 0.001631123978428295));

      expect(measureSin(Measure(-1.59, 0.06)),
          Measure(-0.9984325142269594, 0.0015674857730405556));

      expect(measureSin(Measure(-1.55, 0.06)),
          Measure(-0.9983688760215716, 0.001631123978428295));
    });

    test('measureCos', () {
      expect(measureCos(Measure(0.61, .03)),
          Measure(0.8192792038997398, 0.017183446015447135));

      expect(measureCos(Measure(3.12, 0.06)),
          Measure(-0.9983365828580233, 0.0016634171419767085));

      expect(measureCos(Measure(3.16, 0.06)),
          Measure(-0.9984638592284434, 0.00153614077155656));

      expect(measureCos(Measure(0.02, 0.06)),
          Measure(0.9984008531513098, 0.0015991468486902805));

      expect(measureCos(Measure(-0.02, 0.06)),
          Measure(0.9984008531513098, 0.0015991468486902805));
    });

    test('measureTan', () {
      expect(measureTan(Measure(0.61, .03)),
          Measure(0.699856135491236, 0.04468768672972789));
    });

    test('measureAcos', () {
      expect(measureAcos(Measure(.35, .03)),
          Measure(1.2130334349104512, 0.032033404589815184));
    });

    test('measureAsin', () {
      expect(measureAsin(Measure(.35, .03)),
          Measure(0.3577628918844453, 0.03203340458981524));
    });

    test('measureAtan', () {
      expect(measureAtan(Measure(.35, .03)),
          Measure(0.3364249772443162, 0.02672203270186005));
    });
  });

  group('Numerics Trigonometric Functions:', () {
    setUp(() {
      AppSettings.instance.reset();
    });

    test('numSin(rad)', () {
      expect(numSin(2.32), 0.7322314440302514);

      expect(numSin(-2.32), -0.7322314440302514);

      expect(numSin(1.59), 0.9998156151342908);

      expect(numSin(Measure(2.32, .03)),
          Measure(0.7319019645925077, 0.020428611801663));

      expect(numSin(Measure(1.59, 0.06)),
          Measure(0.9984325142269594, 0.0015674857730405556));

      expect(numSin(Measure(1.55, 0.06)),
          Measure(0.9983688760215716, 0.001631123978428295));

      expect(numSin(Measure(-1.59, 0.06)),
          Measure(-0.9984325142269594, 0.0015674857730405556));

      expect(numSin(Measure(-1.55, 0.06)),
          Measure(-0.9983688760215716, 0.001631123978428295));
    });

    test('numSin(deg)', () {
      AppSettings.instance.toggleIsRadians();

      expect(numSin(35), 0.573576436351046);

      expect(numSin(-35), -0.573576436351046);

      expect(numSin(128), 0.788010753606722);

      expect(numSin(Measure(128, 2)),
          Measure(0.7875307187469627, 0.02148627562798472));

      expect(numSin(Measure(-128, 2)),
          Measure(-0.7875307187469627, 0.02148627562798472));

      expect(numSin(Measure(35, 2)),
          Measure(0.5732270290835376, 0.028587994068510647));
    });

    test('numCos(rad)', () {
      expect(numCos(2.32), -0.6810558805071525);

      expect(numCos(-2.32), -0.6810558805071525);

      expect(numCos(1.59), -0.01920249290169265);

      expect(numCos(Measure(0.61, .03)),
          Measure(0.8192792038997398, 0.017183446015447135));

      expect(numCos(Measure(3.12, 0.06)),
          Measure(-0.9983365828580233, 0.0016634171419767085));

      expect(numCos(Measure(3.16, 0.06)),
          Measure(-0.9984638592284434, 0.00153614077155656));

      expect(numCos(Measure(0.02, 0.06)),
          Measure(0.9984008531513098, 0.0015991468486902805));

      expect(numCos(Measure(-0.02, 0.06)),
          Measure(0.9984008531513098, 0.0015991468486902805));
    });

    test('numCos(deg)', () {
      AppSettings.instance.toggleIsRadians();

      expect(numCos(28.5), 0.8788171126619654);

      expect(numCos(128.5), -0.6225146366376194);

      expect(numCos(-128.5), -0.6225146366376194);

      expect(numCos(Measure(28.5, .8)),
          Measure(0.8787314490932683, 0.006662176661147656));

      expect(numCos(Measure(-28.5, .8)),
          Measure(0.8787314490932683, 0.006662176661147656));

      expect(numCos(Measure(133.7, .5)),
          Measure(-0.6908561043916263, 0.006308998462937865));
    });

    test('numTan(rad)', () {
      expect(numTan(2.32), -1.07514150451941);

      expect(numTan(-2.32), 1.07514150451941);

      expect(numTan(1.59), -52.06696965091235);

      expect(numTan(Measure(0.61, .03)),
          Measure(0.699856135491236, 0.04468768672972789));
    });

    test('numTan(deg)', () {
      AppSettings.instance.toggleIsRadians();

      expect(numTan(128.5), -1.257172298918955);

      expect(numTan(32.3), 0.6321737577491856);

      expect(numTan(-32.3), -0.6321737577491856);

      expect(numTan(Measure(133.7, .5)),
          Measure(-1.046607203275299, 0.018284637049493457));
    });

    test('numAcos(rad)', () {
      expect(numAcos(.345), 1.2185575416978318);

      expect(numAcos(-.762), 2.437192290781323);

      expect(numAcos(Measure(.35, .03)),
          Measure(1.2130334349104512, 0.032033404589815184));

      expect(numAcos(Measure(.324, .008)),
          Measure(1.2408295636269868, 0.008456285629688143));

      expect(numAcos(Measure(-.35, .03)),
          Measure(1.928559218679342, 0.032033404589815295));
    });

    test('numAcos(deg)', () {
      AppSettings.instance.toggleIsRadians();

      expect(numAcos(.345), 69.81820423312259);

      expect(numAcos(-.762), 139.6408321235907);

      expect(numAcos(Measure(.35, .03)),
          Measure(69.50169622862612, 1.83537888643141));

      expect(numAcos(Measure(.324, .008)),
          Measure(71.09429709088599, 0.48450947693825835));

      expect(numAcos(Measure(-.35, .03)),
          Measure(110.4983037713739, 1.8353788864314162));
    });

    test('numAsin(rad)', () {
      expect(numAsin(.345), 0.35223878509706474);

      expect(numAsin(-.762), -0.8663959639864265);

      expect(numAsin(Measure(.35, .03)),
          Measure(0.3577628918844453, 0.03203340458981524));

      expect(numAsin(Measure(.324, .008)),
          Measure(0.3299667631679098, 0.008456285629688254));

      expect(numAsin(Measure(-.35, .03)),
          Measure(-0.3577628918844453, 0.03203340458981524));
    });

    test('numAsin(deg)', () {
      AppSettings.instance.toggleIsRadians();

      expect(numAsin(.345), 20.18179576687741);

      expect(numAsin(-.762), -49.6408321235907);

      expect(numAsin(Measure(.35, .03)),
          Measure(20.498303771373887, 1.8353788864314131));

      expect(numAsin(Measure(.324, .008)),
          Measure(18.905702909114012, 0.4845094769382647));

      expect(numAsin(Measure(-.35, .03)),
          Measure(-20.498303771373887, 1.8353788864314131));
    });

    test('numAtan(rad)', () {
      expect(numAtan(.345), 0.3322135507465967);

      expect(numAtan(-3.235), -1.2709946058035542);

      expect(numAtan(Measure(.56, .03)),
          Measure(0.5101963448413402, 0.022837765336149923));

      expect(numAtan(Measure(3.23, .08)),
          Measure(1.270399665123803, 0.0070008114517278175));

      expect(numAtan(Measure(-6.75, .05)),
          Measure(-1.4237101875733433, 0.0010738815102779853));
    });

    test('numAtan(deg)', () {
      AppSettings.instance.toggleIsRadians();

      expect(numAtan(.345), 19.03443435483519);

      expect(numAtan(-3.235), -72.82262669643742);

      expect(numAtan(Measure(.56, .03)),
          Measure(29.232097282409946, 1.3085075672715605));

      expect(numAtan(Measure(3.23, .08)),
          Measure(72.78853910642704, 0.4011169493508588));

      expect(numAtan(Measure(-6.75, .05)),
          Measure(-81.57258499773135, 0.061528878236063296));
    });
  });
}
