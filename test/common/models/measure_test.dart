import 'package:flutter_test/flutter_test.dart';
import 'package:labcalc2/common/models/measure/measure.dart';

void main() {
  final Measure a = Measure(3.43, .04);
  final Measure b = Measure(2.046, .002);
  final Measure c = Measure(66.23, .03);
  final Measure d = Measure(0.45, .05);

  group('Basics Operations:', () {
    test('add/sub', () {
      Measure r = a + b;
      expect(r, Measure(5.476, 0.042));

      r = a - b;
      expect(r, Measure(1.3840000000000003, 0.042));
      expect(
        r.isApproximatelyEqual(Measure(1.384, 0.042)),
        true,
      );

      r = c + d;
      expect(r, Measure(66.68, 0.08));
    });

    test('mult/div', () {
      Measure r = a * b;
      expect(r, Measure(7.01778, 0.0887));

      r = a * 5;

      expect(r.isApproximatelyEqual(Measure(17.15, 0.2)), true);

      expect(() => a * '2', throwsA(isA<OperationNotAllowed>()));

      r = c / 5;
      expect(r, Measure(13.246, 0.006));

      expect(() => a / '2', throwsA(isA<OperationNotAllowed>()));

      r = c * d;
      expect(r, Measure(29.803500000000003, 3.3250000000000006));
      expect(
        r.isApproximatelyEqual(Measure(29.8035, 3.325)),
        true,
      );

      r = a / b;
      expect(r, Measure(1.6764418377321606, 0.02118909270550554));
      expect(
        r.isApproximatelyEqual(Measure(1.676441838, 0.0211890927)),
        true,
      );
      r = c / d;
      expect(r, Measure(147.17777777777778, 16.419753086419753));
      expect(
        r.isApproximatelyEqual(Measure(147.1777778, 16.41975309)),
        true,
      );
    });

    test('Truncate', () {
      Measure r = a + b;
      expect(r.truncate(), '5.48 ± 0.04');

      r = a - b;
      expect(r.truncate(), '1.38 ± 0.04');

      r = c + d;
      expect(r.truncate(), '66.68 ± 0.08');

      r = c * d;
      expect(r.truncate(), '30 ± 3');

      r = a * b;
      expect(r.truncate(), '7.02 ± 0.09');

      r = a / b;
      expect(r.truncate(), '1.68 ± 0.02');

      r = c / d;
      expect(r.truncate(), '(15 ± 2)E1');

      expect(Measure(12.545, 0.999).truncate(), '13 ± 1');

      expect(Measure(12.545, 230.999).truncate(), '(0 ± 2)E2');

      expect(Measure(0.02342, 0.02349).truncate(), '(2 ± 2)E-2');

      expect(Measure(0.02342, 0.0069).truncate(), '(2.3 ± 0.7)E-2');
    });

    test('Equivalence', () {
      final f = Measure(12.5, .5);

      expect(f.equivalence(Measure(11.0, .5)), false);
      expect(f.equivalence(Measure(11, 1)), true);
      expect(f.equivalence(Measure(11, 2)), true);
      expect(f.equivalence(Measure(12, 1)), true);
      expect(f.equivalence(Measure(13, 1)), true);
      expect(f.equivalence(Measure(13.0, .5)), true);
      expect(f.equivalence(Measure(14, 1)), true);
      expect(f.equivalence(Measure(14.0, .5)), false);

      expect(f.equivalence(11), false);
      expect(f.equivalence(12), true);
      expect(f.equivalence(12.8), true);
      expect(f.equivalence(13.2), false);
      expect(() => f.equivalence('12.5'), throwsA(isA<OperationNotAllowed>()));
    });

    test('Equal', () {
      final Measure a = Measure(3.43, .04);
      final Measure b = Measure(2.046, .002);
      final Measure c = Measure(66.23, .03);
      final Measure d = Measure(0.45, .05);

      expect(a == b, false);
      expect(a == Measure(3.43, .04), true);
      expect(b == c, false);
      expect(b == Measure(2.046, .002), true);
      expect(c != d, true);
      expect(c != Measure(66.23, .03), false);
    });

    test('toString', () {
      expect(a.toString(), '(3.43 ± 0.04)');
    });

    test('toStringAsFixed', () {
      final Measure a = Measure(3.43, .04);
      expect((a * a).toStringAsFixed(5), '(11.76490 ± 0.27440)');
    });

    test('Measure.fromString', () {
      expect(
          Measure.fromString('11.76490 ± 0.27440'), Measure(11.7649, 0.2744));
      expect(
          () => Measure.fromString('str'), throwsA(isA<OperationNotAllowed>()));
    });
  });
}
