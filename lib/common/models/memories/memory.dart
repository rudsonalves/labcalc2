import '../measure/measure.dart';

/// This class implement a exception for memory unsupported type
class MemoryUnsupportedType implements Exception {
  String error() => 'ERROR: memory class unsupported type.';
}

class Memory {
  dynamic _value;

  dynamic get value => _value;

  set value(dynamic newValue) {
    if (newValue is num) {
      _value = newValue.toDouble();
    } else if (newValue is Measure) {
      _value = newValue;
    } else {
      throw MemoryUnsupportedType();
    }
  }

  Memory(newValue) {
    value = newValue;
  }

  bool get isDouble => _value is double;
  bool get isMeasure => _value is Measure;

  @override
  String toString() {
    return 'Memory: $_value';
  }
}
