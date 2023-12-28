import 'package:flutter_test/flutter_test.dart';
import 'package:labcalc2/common/models/measure/measure.dart';
import 'package:labcalc2/common/models/memories/app_memories.dart';
import 'package:labcalc2/common/models/memories/memory.dart';

void main() {
  group('AppMemories:', () {
    test('Constructor and methods', () {
      AppMemories mems = AppMemories.instante;
      mems.init();

      expect(mems.toString().substring(0, 25), 'Memories: A: 0.0  B: 0.0 ');

      mems.setValue('A', 5);
      expect(mems.getValue('A'), 5);

      mems.setValue('Ans', Measure(12, 1));
      expect(mems.getValue('Ans'), Measure(12, 1));

      expect(mems.getValue('Ans') is Measure, true);

      expect(() => mems.setValue('B', 'value'),
          throwsA(isA<MemoryUnsupportedType>()));
    });
  });
}
