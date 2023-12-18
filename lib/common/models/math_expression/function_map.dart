import '../measure/measure_functions.dart';

const Map<String, CallFunction> functionMap = {
  'ln': CallFunction('ln', ln),
  'abs': CallFunction('abs', abs),
  'log': CallFunction('log', log),
  'exp': CallFunction('exp', exp),
  'sin': CallFunction('sin', sin),
  'cos': CallFunction('cos', cos),
  'tan': CallFunction('tan', tan),
  'asin': CallFunction('asin', asin),
  'acos': CallFunction('acos', acos),
  'atan': CallFunction('atan', atan),
  'pow10': CallFunction('pow10', pow10),
  'pow3': CallFunction('pow3', pow3),
  'powy': CallFunction('powy', pow, 2),
  'pow': CallFunction('pow', pow),
  'sqr3': CallFunction('sqr3', sqr3),
  'sqry': CallFunction('sqry', sqry, 2),
  'sqr': CallFunction('sqr', sqr),
};

class CallFunction {
  final String label;
  final Function function;
  final int numberOfParameters;

  const CallFunction(
    this.label,
    this.function, [
    this.numberOfParameters = 1,
  ]);

  double evaluate(double x, [double y = 0]) {
    if (numberOfParameters == 1) {
      return function(x);
    } else {
      return function(x, y);
    }
  }

  @override
  String toString() {
    return (numberOfParameters == 1) ? '$label(x)' : '$label(x,y)';
  }
}
