import 'package:flutter_test/flutter_test.dart';
import 'package:labcalc2/common/models/math_expression/function_map.dart';
import 'package:labcalc2/common/models/math_expression/math_expression.dart';
import 'package:labcalc2/common/models/measure/measure.dart';
import 'package:labcalc2/common/models/measure/measure_functions.dart';
import 'package:labcalc2/common/singletons/app_settings.dart';

void main() {
  group('MathExpression:', () {
    setUp(() {
      AppSettings.instance.reset();
    });

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

    test('expressions with trigonometric functions (rad)', () {
      MathExpression expression = MathExpression.parse('sin(1.25)');
      expect(expression.evaluation(), 0.9489846193555862);

      expression = MathExpression.parse('-sin(1.25)');
      expect(expression.evaluation(), -0.9489846193555862);

      expression = MathExpression.parse('1-sin(1.25)');
      expect(expression.evaluation(), 0.0510153806444138);

      expression = MathExpression.parse('1-cos(1.25)');
      expect(expression.evaluation(), 0.6846776376047313);

      expression = MathExpression.parse('cos(2.12)*sin(1.12)+12');
      expect(expression.evaluation(), 11.530140210723497);

      expression = MathExpression.parse('cos(2.12)*sin(1.12)+12*tan(.23)');
      expect(expression.evaluation(), 2.339860558941081);

      expression =
          MathExpression.parse('-6*cos(2.12)+((4*5-6)*sin(1.12)+12*tan(.23))');
      expect(expression.evaluation(), 18.543175589616897);

      expression = MathExpression.parse('1-2*cos(1.12)*sin(1.12)');
      expect(expression.evaluation(), 0.21568407491558006);

      expression = MathExpression.parse('tan(1.12)-sin(1.12)/cos(1.12)');
      expect(expression.evaluation(), 0);
    });

    test('expressions with trigonometric functions (deg)', () {
      AppSettings.instance.toggleIsRadians();

      MathExpression expression = MathExpression.parse('sin(30)');
      expect(expression.evaluation(), 0.49999999999999994);

      expression = MathExpression.parse('-sin(60)');
      expect(expression.evaluation(), -0.8660254037844386);

      expression = MathExpression.parse('1-sin(30)');
      expect(expression.evaluation(), 0.5);

      expression = MathExpression.parse('1-cos(35)');
      expect(expression.evaluation(), 0.1808479557110082);

      expression = MathExpression.parse('-cos(32)*sin(45)*12+12');
      expect(expression.evaluation(), 4.8040732852254);

      expression = MathExpression.parse('cos(25)*sin(52)+12*tan(74)');
      expect(expression.evaluation(), 42.563153608353296);

      expression =
          MathExpression.parse('-6*cos(24)+((4*5-6)*sin(74)+12*tan(12))');
      expect(expression.evaluation(), 10.527069737321124);

      expression = MathExpression.parse('1-2*cos(24)*sin(24)');
      expect(expression.evaluation(), 0.25685517452260587);

      expression = MathExpression.parse('tan(12)-sin(12)/cos(12)');
      expect(expression.evaluation(), 0);
    });

    test('method evaluation with functions and parentheses', () {
      MathExpression expression =
          MathExpression.parse('(15-5*ln(22.15)*(18*sqr(2)-10))+250');
      expect(expression.evaluation(), 25.601532683644905);

      expression = MathExpression.parse('log(20)');
      expect(expression.evaluation(), 1.301029995663981);

      expression = MathExpression.parse('(15-5*log(22.15)*(18*sqr(2)-10))+250');
      expect(expression.evaluation(), 161.030566668411);

      expression = MathExpression.parse('pow3(15)');
      expect(expression.evaluation(), 3375);

      expression = MathExpression.parse('powy(2,4)+5');
      expect(expression.evaluation(), 21);

      expression = MathExpression.parse('powy(1.15,6)');
      expect(expression.evaluation(), 2.313060765624999);

      expression = MathExpression.parse('sqry(2.313060765624999,6)');
      expect(expression.evaluation(), 1.15);

      expression = MathExpression.parse('-(sqry(2.313060765624999,6) + 1.85)');
      expect(expression.evaluation(), -3);

      expression =
          MathExpression.parse('abs(-(sqry(2.313060765624999,6) + 1.85))');
      expect(expression.evaluation(), 3);
    });

    test('method evaluation Measure', () {
      MathExpression expression = MathExpression.parse('(12±2)');
      expect(expression.evaluation(), Measure(12, 2));

      expression = MathExpression.parse('(12±2)+(3±1)');
      expect(expression.evaluation(), Measure(15, 3));

      expression = MathExpression.parse('2*((12±2)+(3±1))');
      expect(expression.evaluation(), Measure(30, 6));

      expression = MathExpression.parse('-2*((12±2)+(3±1))');
      expect(expression.evaluation(), Measure(-30, 6));

      expression = MathExpression.parse('-pow(3±1)');
      expect(expression.evaluation(), Measure(-9, 6));

      expression = MathExpression.parse('-pow(3±.1)');
      expect(expression.evaluation(), Measure(-9, .6));

      expression = MathExpression.parse('-4*log(12±2)+2*(3±1)');
      expect(expression.evaluation(),
          Measure(1.7077439286435245, 2.2922560713564755));

      expression = MathExpression.parse('-2*((12±2)+(3±1))');
      expect(expression.evaluation(), Measure(-30, 6));
    });
  });
}
