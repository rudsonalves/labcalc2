import 'package:labcalc2/common/models/measure/measure.dart';

import '../measure/measure_functions.dart';
import '../memories/app_memories.dart';
import 'function_map.dart';

/// Mathematical expression error
class MathExpressionError implements Exception {
  final Object? err;
  MathExpressionError([this.err]);
  String error() {
    if (err != null) {
      return "ERROR: error in mathematical expression ($err)";
    }
    return "ERROR: error in mathematical expression";
  }
}

/// Class that represents a mathematical expression and allows its evaluation.
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

  /// Creates an instance of MathExpression from a string.
  factory MathExpression.parse(String strExpression) {
    List<dynamic> expression = [];

    // Substitutions to handle special cases in the expression.
    String newString = strExpression
        .replaceAll('-(', '-1*(')
        .replaceAll('-', '+-')
        .replaceAll('(+', '(')
        .replaceAll('e+-', 'e-')
        .replaceAllMapped(RegExp(r'(?<=\D)\.(?=\d)'), (match) => '0.')
        .replaceAllMapped(RegExp(r'-(?=[A-Za-z])'), (match) => '-1*');

    newString = (newString[0] == '+') ? newString.substring(1) : newString;

    // Regex to capture numbers, functions, commas and other characters.
    RegExp regExp = RegExp(
        r'(-?\d+(\.\d+)?(e[+\-]?\d+)?)|'
        r'(ln|abs|log|exp|sin|cos|tan|asin|acos|atan|pow10|pow3|powy|pow|sqr3|sqry|sqr|Ans|xm)'
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

  /// Evaluates the mathematical expression.
  dynamic evaluation() {
    if (_expression.isEmpty) return null;

    try {
      List<dynamic> solve = List.from(_expression);

      // solve expressions in parentheses
      while (solve.contains('(')) {
        int start;
        int end;

        // takes the positions of the innermost parentheses
        (start, end) = _findNextParentheses(solve);

        // checks if the parentheses are broken
        if (start * end < 0) throw MathExpressionError();

        // evaluates the expression between the parentheses
        List<dynamic> toSolve = solve.sublist(start + 1, end);
        dynamic result;
        // do not process expressions with only 1 element
        if (toSolve.length == 1) {
          result = toSolve.first;
        } else if (toSolve.length == 3 && toSolve[1] == '±') {
          result = _measureEvaluator(toSolve);
        } else {
          result = _basicSolve(solve.sublist(start + 1, end));
        }

        // Remove the expression between the parentheses and replace it
        // with your result.
        solve.removeRange(start, end);
        if (result is List) {
          // adds attributes to two-argument functions
          solve.removeAt(start);
          solve.insertAll(start, result);
        } else {
          solve[start] = result;
        }
      }

      dynamic result = _basicSolve(solve);

      // Checks if the solution is valid.
      if (result is List) throw Exception('evaluation return a list "$result"');

      return result;
    } catch (err) {
      // Throws a custom exception on error.
      throw MathExpressionError(err);
    }
  }

  // This function searches for the positions of the innermost parentheses
  // of the expression
  (int, int) _findNextParentheses(List<dynamic> solve) {
    int startIndex = 0;
    int endIndex = 0;
    int nextIndex = -1;
    int depth = 0;

    while (true) {
      // location of the first open parentheses in front of depth
      startIndex = solve.indexOf('(', depth);
      // location of the first close parentheses in front of depth
      endIndex = solve.indexOf(')', depth);
      // location of the first open parentheses in front of startIndex + 1
      nextIndex = solve.indexOf('(', startIndex + 1);

      // checks that there are no opening parentheses in front of startIndex
      if (nextIndex != -1) {
        // checks if the next open parentheses (nextIndex) is before the next
        // close parentheses (endIndex)
        if (nextIndex < endIndex) {
          // starts the search for innermost parentheses by updating the depth
          depth = nextIndex;
          nextIndex = -1;
        } else {
          // innermost parentheses found with an opening parentheses
          // subsequent to the closing found
          break;
        }
      } else {
        // innermost parentheses found
        break;
      }
    }
    return (startIndex, endIndex);
  }

  dynamic _basicSolve(List<dynamic> expression) {
    // Apply the _memoriesEvaluator method to recover memories
    List<dynamic> solve = _memoriesEvaluator(expression);
    // Apply the _measureEvaluator method to conver measures
    solve = _measureEvaluator(solve);
    // Apply the _functionEvaluator method to resolve functions
    solve = _functionEvaluator(solve);

    // Processes multiplications and divisions.
    while (solve.contains('*') | solve.contains('/')) {
      int prodIndex = solve.indexOf('*');
      int divIndex = solve.indexOf('/');

      prodIndex = prodIndex != -1 ? prodIndex : divIndex;
      divIndex = divIndex != -1 ? divIndex : prodIndex;

      int index = prodIndex < divIndex ? prodIndex : divIndex;
      Function operation = solve[index] == '*' ? multiplication : division;

      dynamic result = operation(solve[index - 1], solve[index + 1]);
      solve.removeRange(index - 1, index + 1);
      solve[index - 1] = result;
    }

    // Process additions
    while (solve.contains('+')) {
      int index = solve.indexOf('+');

      dynamic result = addition(solve[index - 1], solve[index + 1]);
      solve.removeRange(index - 1, index + 1);
      solve[index - 1] = result;
    }

    // Checks if the solution is valid.
    if (solve.length > 1) {
      // checks if solve is a double argument of a function or Measure
      if (solve.length == 3) {
        if (solve[1] == ',' || solve[1] == '') {
          return solve;
        } else {
          throw Exception('Solve return "$solve"');
        }
      } else {
        throw Exception('Solve return "$solve"');
      }
    }

    return solve.first;
  }

  /// This method applies mathematical functions, declared as CallFunction,
  /// on the elements of the passed dynamic list. The expression cannot contain
  /// parentheses.
  List<dynamic> _functionEvaluator(List<dynamic> expression) {
    List<dynamic> solve = [];

    int index = 0;

    while (index < expression.length) {
      final value = expression[index];

      if (value is CallFunction) {
        int numberOfParameters = value.numberOfParameters;

        switch (numberOfParameters) {
          case 1:
            // advances to the first parameter
            index++;
            // calculates the result of the function and adds the return
            // solve list
            dynamic result = value.function(expression[index]);
            solve.add(result);
            break;
          case 2:
            // advances to the first parameter and collects it
            index++;
            dynamic parameter1 = expression[index];
            // advances by skipping comma, then collects the second parameter.
            index += 2;
            dynamic parameter2 = expression[index];
            // applies the parameters to the function and adds the result to
            // the solve list
            dynamic result = value.function(parameter1, parameter2);
            solve.add(result);
            break;
          default:
            throw MathExpressionError(
                'incorrect number of parameters in the ${value.label} function');
        }
      } else {
        // add to solve list
        solve.add(value);
      }
      index++;
    }

    return solve;
  }

  /// This method transforms two numeric values separated by the '±' character
  /// into a Measure
  List<dynamic> _measureEvaluator(List<dynamic> expression) {
    List<dynamic> solve = List.from(expression);

    int tokenIndex = solve.indexOf('±');

    while (tokenIndex != -1) {
      final measure = Measure(solve[tokenIndex - 1], solve[tokenIndex + 1]);
      solve.removeRange(tokenIndex - 1, tokenIndex + 1);
      solve[tokenIndex - 1] = measure;

      tokenIndex = solve.indexOf('±');
    }

    return solve;
  }

  /// This method replaces memory labels and pi with their numeric or
  /// measurement values.
  List<dynamic> _memoriesEvaluator(List<dynamic> expression) {
    final memories = AppMemories.instante;

    List<dynamic> solve = [];

    for (dynamic value in expression) {
      if (memoriesLabels.contains(value)) {
        solve.add(memories.getValue(value));
      } else {
        solve.add(value);
      }
    }

    return solve;
  }

  @override
  String toString() {
    return _expression.toString();
  }
}
