import 'package:flutter_test/flutter_test.dart';
import 'package:labcalc2/common/models/math_expression/function_map.dart';
import 'package:labcalc2/common/models/math_expression/math_expression.dart';
import 'package:labcalc2/common/models/measure/measure_functions.dart';

void main() {
  group('MathExpression:', () {
    test('method parser', () {
      expect(
        MathExpression.parse('12.23+56.3*34.7').expression,
        [12.23, '+', 56.3, '*', 34.7],
      );

      expect(
        MathExpression.parse('1.2+2.3e-3*56/14').expression,
        [1.2, '+', 0.0023, '*', 56, '/', 14],
      );

      expect(
        MathExpression.parse('-3*(4+8/5)').expression,
        [-3, '*', '(', 4, '+', 8, '/', 5, ')'],
      );

      expect(
        MathExpression.parse('-3*(-4-8/5)').expression,
        [-3, '*', '(', -4, '+', -8, '/', 5, ')'],
      );

      expect(
        MathExpression.parse('-(3+4-8/5)').expression,
        [-1, '*', '(', 3, '+', 4, '+', -8, '/', 5, ')'],
      );

      expect(
        MathExpression.parse('sin(1.2+2.3e-3)*56/14').expression,
        [
          const CallFunction('sin', sin),
          '(',
          1.2,
          '+',
          2.3e-3,
          ')',
          '*',
          56.0,
          '/',
          14.0
        ],
      );

      expect(
        MathExpression.parse('cos(1.2+2.3e-3)*56/14').expression,
        [
          const CallFunction('cos', cos),
          '(',
          1.2,
          '+',
          2.3e-3,
          ')',
          '*',
          56.0,
          '/',
          14.0
        ],
      );

      expect(
        MathExpression.parse('tan(1.2+2.3e-3)*56/14').expression,
        [
          const CallFunction('tan', tan),
          '(',
          1.2,
          '+',
          2.3e-3,
          ')',
          '*',
          56.0,
          '/',
          14.0
        ],
      );

      expect(
        MathExpression.parse('asin(1.2+2.3e-3)*56/14').expression,
        [
          const CallFunction('asin', asin),
          '(',
          1.2,
          '+',
          2.3e-3,
          ')',
          '*',
          56.0,
          '/',
          14.0
        ],
      );

      expect(
        MathExpression.parse('acos(1.2+2.3e-3)*56/14').expression,
        [
          const CallFunction('acos', acos),
          '(',
          1.2,
          '+',
          2.3e-3,
          ')',
          '*',
          56.0,
          '/',
          14.0
        ],
      );

      expect(
        MathExpression.parse('atan(1.2+2.3e-3)*56/14').expression,
        [
          const CallFunction('atan', atan),
          '(',
          1.2,
          '+',
          2.3e-3,
          ')',
          '*',
          56.0,
          '/',
          14.0
        ],
      );

      expect(
        MathExpression.parse('-2.5e-2*sqr3(-13.5)').expression,
        [-2.5e-2, '*', const CallFunction('sqr3', sqr3), '(', -13.5, ')'],
      );

      expect(
        MathExpression.parse('-12*powy(3,7.3)').expression,
        [-12, '*', const CallFunction('powy', pow, 2), '(', 3, ',', 7.3, ')'],
      );

      expect(
        MathExpression.parse('-12*pow(3)').expression,
        [-12, '*', const CallFunction('pow', pow), '(', 3, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*pow3(-3*1.5)').expression,
        [-1e-2, '*', const CallFunction('pow3', pow3), '(', -3, '*', 1.5, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*sqr(3*1.5)').expression,
        [-1e-2, '*', const CallFunction('sqr', sqr), '(', 3, '*', 1.5, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*sqr3(3*1.5)').expression,
        [-1e-2, '*', const CallFunction('sqr3', sqr3), '(', 3, '*', 1.5, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*sqry(3*1.5,5)').expression,
        [
          -1e-2,
          '*',
          const CallFunction('sqry', sqry, 2),
          '(',
          3,
          '*',
          1.5,
          ',',
          5,
          ')'
        ],
      );

      expect(
        MathExpression.parse('-1e-2*ln(3*1.5)').expression,
        [-1e-2, '*', const CallFunction('ln', ln), '(', 3, '*', 1.5, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*log(3*1.5)').expression,
        [-1e-2, '*', const CallFunction('log', log), '(', 3, '*', 1.5, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*exp(3*1.5)').expression,
        [-1e-2, '*', const CallFunction('exp', exp), '(', 3, '*', 1.5, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*pow10(3*1.5)').expression,
        [-1e-2, '*', const CallFunction('pow10', pow10), '(', 3, '*', 1.5, ')'],
      );

      expect(
        MathExpression.parse('-1e-2*abs(3*1.5)').expression,
        [-1e-2, '*', const CallFunction('abs', abs), '(', 3, '*', 1.5, ')'],
      );
    });
  });
}



/// ln|abs|log|exp|pow10|