import 'function_map.dart';

class MathExpression {
  final String strExpression;
  final List<dynamic> _expression = [];

  List<dynamic> get expression => _expression;

  MathExpression({
    required this.strExpression,
    required List<dynamic> expression,
  }) {
    _expression.addAll(expression);
  }

  factory MathExpression.parse(String strExpression) {
    List<dynamic> expression = [];

    // Substitutions to handle special cases
    String newString = strExpression
        .replaceAll('-(', '-1*(')
        .replaceAll('-', '+-')
        .replaceAll('(+', '(')
        .replaceAll('e+-', 'e-')
        .replaceAllMapped(RegExp(r'(?<=\D)\.(?=\d)'), (match) => '0.');

    newString = (newString[0] == '+') ? newString.substring(1) : newString;

    // Updated regex to capture numbers, functions, commas and other characters
    RegExp regExp = RegExp(
        r'(-?\d+(\.\d+)?(e[+\-]?\d+)?)|'
        r'(ln|abs|log|exp|sin|cos|tan|asin|acos|atan|pow10|pow3|powy|pow|sqr3|sqry|sqr)'
        r'|(\,)|(\S)',
        caseSensitive: true);

    regExp.allMatches(newString).forEach((match) {
      String token = match.group(0)!;

      if (functionMap.containsKey(token)) {
        expression.add(functionMap[token]);
      } else if (token == ',') {
        expression.add(token); // Treats the comma as a parameter separator
      } else {
        // Try converting to double, otherwise keep it as string
        expression.add(double.tryParse(token) ?? token);
      }
    });

    return MathExpression(
      strExpression: strExpression,
      expression: expression,
    );
  }

  @override
  String toString() {
    return _expression.toString();
  }
}
