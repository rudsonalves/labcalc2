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

    test('method evaluation', () {
      MathExpression expression = MathExpression.parse('21*2/3-10/2*5');
      expect(expression.evaluation(), -11);

      expression = MathExpression.parse('5+8*9/2*5/9*8+21');
      expect(expression.evaluation(), 186);

      expression = MathExpression.parse('8+15-3+22-7');
      expect(expression.evaluation(), 35);

      expression = MathExpression.parse('10*2-3+5/2');
      expect(expression.evaluation(), 19.5);

      expression = MathExpression.parse('6*4*2*0.5');
      expect(expression.evaluation(), 24);

      expression = MathExpression.parse('100/4-5/2-10');
      expect(expression.evaluation(), 12.5);

      expression = MathExpression.parse('8*3/2-5+14/2+6');
      expect(expression.evaluation(), 20);

      expression = MathExpression.parse('8**3/2-5+14/2+6');
      expect(
          () => expression.evaluation(), throwsA(isA<MathExpressionError>()));
    });

    test('method evaluation with parentheses', () {
      MathExpression expression = MathExpression.parse('(5+2*(6-2))');
      expect(expression.evaluation(), 13);

      expression = MathExpression.parse('(5+2*(6-2))+18/3*(10-3)');
      expect(expression.evaluation(), 55);

      expression = MathExpression.parse('(3+(4*5))/(2*3)');
      expect(expression.evaluation(), 3.8333333333333335);

      expression = MathExpression.parse('((2+3)*(3+4))/7');
      expect(expression.evaluation(), 5);

      expression = MathExpression.parse('18/(3*(2+1))');
      expect(expression.evaluation(), 2);

      expression = MathExpression.parse('(15-3*(2+4))');
      expect(expression.evaluation(), -3);

      expression = MathExpression.parse('(5*(3+2)-4)/(2+(3/1))');
      expect(expression.evaluation(), 4.2);

      expression = MathExpression.parse('5+3*(3+7)/2+(30+6)/(5+1)');
      expect(expression.evaluation(), 26);

      expression = MathExpression.parse('5+3*(3+7)/2+((30+6)/(5+1))');
      expect(expression.evaluation(), 26);

      expression = MathExpression.parse('(8*3/2)-((5+14)/(2+6)');
      expect(
          () => expression.evaluation(), throwsA(isA<MathExpressionError>()));

      expression = MathExpression.parse('(8*3/2)-(5+14))/(2+6)');
      expect(
          () => expression.evaluation(), throwsA(isA<MathExpressionError>()));
    });
  });
}



/// ln|abs|log|exp|pow10|