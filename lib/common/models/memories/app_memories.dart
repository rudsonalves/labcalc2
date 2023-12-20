import '../measure/measure_functions.dart';
import 'memory.dart';

const List<String> memoriesLabels = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'Ans',
  'xm',
  'π',
];

class AppMemories {
  AppMemories._();
  static final _instance = AppMemories._();
  static AppMemories instante = _instance;

  final Map<String, Memory> _memories = {};

  Map<String, Memory> get memories => _memories;

  void init() {
    resetMemories();
  }

  void resetMemories() {
    _memories.clear();
    _memories.addEntries(
      memoriesLabels.map(
        (element) => MapEntry(element, Memory(0)),
      ),
    );
    setValue('π', pi);
  }

  dynamic getValue(String label) => _memories[label]!.value;

  void setValue(String label, dynamic value) => _memories[label]!.value = value;

  @override
  String toString() {
    String stringValue = 'Memories: ';
    for (String label in _memories.keys) {
      stringValue += '$label: ${getValue(label)}  ';
    }
    return stringValue.trim();
  }
}
