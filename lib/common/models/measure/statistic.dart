import '../../singletons/app_settings.dart';
import 'measure.dart';
import 'measure_functions.dart';

class StatisticController {
  StatisticController._();
  static final _instance = StatisticController._();
  static StatisticController get instance => _instance;

  final _app = AppSettings.instance;

  final List<double> _values = [];
  List<double> get values => _values;

  Measure _mean = Measure();

  void add(double value) {
    _values.add(value);
    _app.setCounter(length);
  }

  void removeLast() {
    _values.removeLast();
    _app.setCounter(length);
  }

  void clear() {
    _values.clear();
    _app.setCounter(0);
  }

  bool get isEmpty => _values.isEmpty;
  bool get isNotEmpty => _values.isNotEmpty;

  int get length => _values.length;

  Measure get mean => _calculate();

  Measure _calculate() {
    _mean = calculateXm(_values);
    return _mean;
  }
}
