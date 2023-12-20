import 'package:flutter_test/flutter_test.dart';
import 'package:labcalc2/common/models/measure/measure.dart';
import 'package:labcalc2/common/models/memories/memory.dart';

void main() {
  group('Memory:', () {
    test('constructor and metods', () {
      Memory a = Memory(5);
      expect(a.isDouble, true);
      expect(a.isMeasure, false);
      expect(a.toString(), 'Memory: 5.0');

      a = Memory(Measure(2, .1));
      expect(a.isDouble, false);
      expect(a.isMeasure, true);
      expect(a.toString(), 'Memory: 2.0 ± 0.1');

      expect(() => a = Memory('value'), throwsA(isA<MemoryUnsupportedType>()));
    });
  });
}
