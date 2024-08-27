// Copyright (C) 2024 Rudson Alves
// 
// This file is part of labcalc2.
// 
// labcalc2 is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// labcalc2 is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with labcalc2.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:math' as math;

import '../../constants/constants.dart';
import '../../singletons/app_settings.dart';
import 'measure.dart';

bool isRadian() {
  return AppSettings.instance.isRadians;
}

const pi = math.pi;

/*
Statistical functions
*/
/// Return a Measure mean and deviation using a mean and
/// a deviation mathematical models.
Measure calculateXm(List<double> values) {
  final mean = AppSettings.instance.mean;
  final deviation = AppSettings.instance.deviation;

  double xm;
  double dxm;

  switch (mean) {
    case TypeMean.arithmetic:
      xm = arithmeticMean(values);
      break;
    case TypeMean.harmonic:
      xm = harmonicMean(values);
      break;
    case TypeMean.rms:
      xm = rmsMean(values);
      break;
    default:
      throw OperationNotAllowed();
  }

  switch (deviation) {
    case TypeDeviation.meanDeviation:
      dxm = simpleMeaDeviation(values, xm);
      break;
    case TypeDeviation.sampleStdDeviation:
      dxm = sampleStandardDeviation(values, xm);
      break;
    case TypeDeviation.popStdDeviation:
      dxm = popsStandardDeviation(values, xm);
      break;
    default:
      throw OperationNotAllowed();
  }

  return Measure(xm, dxm);
}

/// Return a mean using a arithmetic mean model.
double arithmeticMean(List<double> xs) {
  return xs.reduce((a, b) => a + b) / xs.length;
}

/// Return a mean using a harmonic mean model.
double harmonicMean(List<double> xs) {
  double s = 0;
  for (double v in xs) {
    s += 1 / v;
  }
  return xs.length / s;
}

/// Return a mean using a rms mean model.
double rmsMean(List<double> xs) {
  double s = 0;
  for (double v in xs) {
    s += v * v;
  }
  return math.sqrt(s / xs.length);
}

/// Return a deviation using a Simple Mean Deviation model.
double simpleMeaDeviation(List<double> xs, double xm) {
  return xs.map((xi) => (xm - xi).abs()).reduce((a, b) => a + b) / xs.length;
}

/// Return a deviation using a Sample Standard Deviation model.
double sampleStandardDeviation(List<double> xs, double xm) {
  return math.sqrt(
          xs.map((xi) => math.pow((xm - xi), 2)).reduce((a, b) => a + b)) /
      (xs.length - 1);
}

/// Return a deviation using a Population Standard Deviation model.
double popsStandardDeviation(List<double> xs, double xm) {
  return math.sqrt(
          xs.map((xi) => math.pow((xm - xi), 2)).reduce((a, b) => a + b)) /
      xs.length;
}

/// Return a sum of xs elements
double sumAll(List<double> xs) {
  return xs.reduce((value, element) => value + element);
}

/// Return the order of magnitude of the passed value. This function
/// is required for the truncate function.
int getOrder(double value) {
  int n = 0;

  if (value > 10) {
    while (value > 10) {
      n--;
      value /= 10;
    }
    n = (value.round() == 10) ? n - 1 : n;
  } else {
    while (value < 1) {
      n++;
      value *= 10;
    }
    n = (value.round() == 10) ? n - 1 : n;
  }

  return n;
}

/*
Math functions of class Measure
*/
Measure measureAbs(Measure m) {
  return Measure(m.value.abs(), m.delta);
}

Measure measurePow(Measure m, double n) {
  final double r = math.pow(m.value, n).toDouble();
  return Measure(r, (r * n * m.delta / m.value).abs());
}

Measure measureSqrt(Measure m) {
  final double r = math.sqrt(m.value);
  return Measure(r, r.abs() * 0.5 * m.delta / m.value);
}

Measure measureFunction(Measure m, Function function) {
  final double f0 = function(m.value + m.delta);
  final double f1 = function(m.value - m.delta);
  return Measure((f0 + f1) / 2, (f0 - f1).abs() / 2);
}

Measure measureSin(Measure m) {
  final double v0 = m.value + m.delta;
  final double v1 = m.value - m.delta;
  final double s0 = math.sin(v0);
  final double s1 = math.sin(v1);
  // Checks by the derivative if the function
  // is in a range of maximum/minimum
  if (math.cos(v0) * math.cos(v1) < 0) {
    if (s0 > 0) {
      // Is a maximum
      final double d0 = 1 - s0;
      final double d1 = 1 - s1;
      // Use the biggest deviation
      if (d0 > d1) {
        return Measure((s0 + 1) / 2, d0 / 2);
      } else {
        return Measure((s1 + 1) / 2, d1 / 2);
      }
    } else {
      // Is a minimum
      final double d0 = 1 + s0;
      final double d1 = 1 + s1;
      // Use the biggest deviation
      if (d0 > d1) {
        return Measure((-1 + s0) / 2, d0 / 2);
      } else {
        return Measure((-1 + s1) / 2, d1 / 2);
      }
    }
  }
  return Measure((s0 + s1) / 2, (s0 - s1).abs() / 2);
}

Measure measureCos(Measure m) {
  final double v0 = m.value + m.delta;
  final double v1 = m.value - m.delta;
  final double s0 = math.cos(v0);
  final double s1 = math.cos(v1);
  // Checks by the derivative if the function
  // is in a range of maximum/minimum
  if (math.sin(v0) * math.sin(v1) < 0) {
    if (s0 > 0) {
      // Is a maximum
      final double d0 = 1 - s0;
      final double d1 = 1 - s1;
      // Use the biggest deviation
      if (d0 > d1) {
        return Measure((s0 + 1) / 2, d0 / 2);
      } else {
        return Measure((s1 + 1) / 2, d1 / 2);
      }
    } else {
      // Is a minimum
      final double d0 = 1 + s0;
      final double d1 = 1 + s1;
      // Use the biggest deviation
      if (d0 > d1) {
        return Measure((-1 + s0) / 2, d0 / 2);
      } else {
        return Measure((-1 + s1) / 2, d1 / 2);
      }
    }
  }
  return Measure((s0 + s1) / 2, (s0 - s1).abs() / 2);
}

Measure measureTan(Measure m) {
  return measureFunction(m, math.tan);
}

Measure measureLn(Measure m) {
  return measureFunction(m, math.log);
}

Measure measureLog(Measure m) {
  return measureFunction(m, mathLog10);
}

Measure measureAcos(Measure m) {
  return measureFunction(m, math.acos);
}

Measure measureAsin(Measure m) {
  return measureFunction(m, math.asin);
}

Measure measureAtan(Measure m) {
  return measureFunction(m, math.atan);
}

Measure measureExp(Measure m) {
  return measureFunction(m, math.exp);
}

Measure measurePow10(Measure m) {
  return measureFunction(m, mathPow10);
}

/*
 Some functions
*/
double mathLog10(double value) {
  return math.log(value) / math.log(10);
}

double mathAbs(double value) {
  return value.abs();
}

double mathPow10(double value) {
  return math.pow(10, value).toDouble();
}

/* ---------------------------------------
 Generics functions return values according
 to the input parameters

 Basics operations
*/
/// Return A + B
dynamic addition(dynamic A, dynamic B) {
  if (((A is Measure) && (B is num)) || ((A is num) && (B is Measure))) {
    throw OperationNotAllowed();
  }
  return A + B;
}

/// Return A - B
dynamic subtraction(dynamic A, dynamic B) {
  if (((A is Measure) && (B is num)) || ((A is num) && (B is Measure))) {
    throw OperationNotAllowed();
  }
  return A - B;
}

/// Return A*B
dynamic multiplication(dynamic A, dynamic B) {
  if ((A.runtimeType == B.runtimeType) || ((A is num) && (B is num))) {
    return A * B;
  } else if (A is num && B is Measure) {
    return B * A.toDouble();
  } else if (B is num && A is Measure) {
    return A * B.toDouble();
  }
  throw OperationNotAllowed();
}

/// Return A/B
dynamic division(dynamic A, dynamic B) {
  if ((A.runtimeType == B.runtimeType) || ((A is num) && (B is num))) {
    return A / B;
  } else if (A is num && B is Measure) {
    return measurePow(B, -1) * A;
  } else if (B is num && A is Measure) {
    return A / B;
  }
  throw OperationNotAllowed();
}

/* ---------------------------------------
 Generics functions return values according
 to the input parameters
*/

/// This function returns the absolute value of a Measure/double of an argument
/// value
dynamic abs(dynamic value) {
  if (value is Measure) {
    return measureAbs(value);
  } else if (value is num) {
    return mathAbs(value.toDouble());
  } else {
    throw OperationNotAllowed();
  }
}

/// This function returns the natural logarithm of a Measure/double of an
/// argument value
dynamic ln(dynamic value) {
  if (value is Measure) {
    return measureLn(value);
  } else if (value is num) {
    return math.log(value);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function returns the logarithm base 10 of a Measure/double of an argument value
dynamic log(dynamic value) {
  if (value is Measure) {
    return measureLog(value);
  } else if (value is num) {
    return mathLog10(value.toDouble());
  } else {
    throw OperationNotAllowed();
  }
}

/// This function returns the power of 'p' of a Measure/double of an argument value
dynamic pow(dynamic value, [double p = 2]) {
  if (value is Measure) {
    return measurePow(value, p);
  } else if (value is num) {
    return math.pow(value, p);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 1/p of a Measure/double of an argument value
dynamic sqry(dynamic value, double p) {
  if (value is Measure) {
    return measurePow(value, 1 / p);
  } else if (value is num) {
    return math.pow(value, 1 / p);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 2 of a Measure/double of an argument value
dynamic pow2(dynamic value) => pow(value);

/// This function return the power 3 of a Measure/double of an argument value
dynamic pow3(dynamic value) {
  if (value is Measure) {
    return measurePow(value, 3);
  } else if (value is num) {
    return math.pow(value, 3);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 1/3 of a Measure/double of an argument value
dynamic sqr3(dynamic value) {
  if (value is Measure) {
    return measurePow(value, 1 / 3.0);
  } else if (value is num) {
    return math.pow(value, 1 / 3.0);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 10 of a Measure/double of an argument value
dynamic pow10(dynamic value) {
  if (value is Measure) {
    return measurePow10(value);
  } else if (value is num) {
    return mathPow10(value.toDouble());
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the exponent of a Measure/double of an argument value
dynamic exp(dynamic value) {
  if (value is Measure) {
    return measureExp(value);
  } else if (value is num) {
    return math.exp(value);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the square root of a Measure/double of an argument value
dynamic sqr(dynamic value) {
  if (value is Measure) {
    return measureSqrt(value);
  } else if (value is num) {
    return math.sqrt(value);
  } else {
    throw OperationNotAllowed();
  }
}

/*
 Trigonometric functions
*/
dynamic _trigonometricFunction(dynamic angle, Function func) {
  final value = !isRadian() ? angle * pi / 180 : angle;
  if (value is Measure) {
    switch (func) {
      case math.sin:
        return measureSin(value);
      case math.cos:
        return measureCos(value);
      case math.tan:
        return measureTan(value);
      default:
        throw OperationNotAllowed();
    }
  } else if (value is num) {
    if (func == math.sin || func == math.cos || func == math.tan) {
      return func(value.toDouble());
    } else {
      throw OperationNotAllowed();
    }
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the cosine of a Measure/double of an argument value in degree
dynamic cos(dynamic value) {
  return _trigonometricFunction(value, math.cos);
}

/// This function return the sine of a Measure/double of an argument value in degree
dynamic sin(dynamic value) {
  return _trigonometricFunction(value, math.sin);
}

/// This function return the tangent of a Measure/double of an argument value in degree
dynamic tan(dynamic value) {
  return _trigonometricFunction(value, math.tan);
}

dynamic _trigonometricInverseFunction(dynamic value, Function func) {
  late dynamic angle;
  if (value is Measure) {
    switch (func) {
      case math.asin:
        angle = measureAsin(value);
        break;
      case math.acos:
        angle = measureAcos(value);
        break;
      case math.atan:
        angle = measureAtan(value);
        break;
      default:
        throw OperationNotAllowed();
    }
  } else if (value is num) {
    if ([math.asin, math.acos, math.atan].contains(func)) {
      angle = func(value.toDouble());
    } else {
      throw OperationNotAllowed();
    }
  } else {
    throw OperationNotAllowed();
  }
  return !isRadian() ? angle * 180 / pi : angle;
}

/// This function return the arc-cosine in degree of a Measure/double of an argument value
dynamic acos(dynamic value) {
  return _trigonometricInverseFunction(value, math.acos);
}

/// This function return the arc-sine in degree of a Measure/double of an argument value
dynamic asin(dynamic value) {
  return _trigonometricInverseFunction(value, math.asin);
}

/// This function return the arc-tangent in degree of a Measure/double of an argument value
dynamic atan(dynamic value) {
  return _trigonometricInverseFunction(value, math.atan);
}

dynamic pol(dynamic x, dynamic y) {
  dynamic r = sqr(pow(x) + pow(y));
  dynamic o = atan(y / x);

  return PolarRepresentation(r, o);
}

dynamic rec(dynamic r, dynamic o) {
  dynamic x = r * cos(o);
  dynamic y = r * sin(o);

  return RectRepresentation(x, y);
}

class PolarRepresentation {
  final dynamic radius;
  final dynamic angle;

  PolarRepresentation(
    this.radius,
    this.angle,
  );

  @override
  String toString() {
    if (isRadian()) {
      dynamic newAngle = angle * 180.0 / pi;
      return 'Polar(r: $radius, 𝚹: $newAngle°)';
    }

    return 'Polar(r: $radius, 𝚹: $angle)';
  }

  String toStringAsFixed(int precision) {
    String strR = radius.toStringAsFixed(precision);

    String strO = angle.toStringAsFixed(precision);
    return 'Polar(r: $strR, 𝚹: $strO°)';
  }

  /// toStringByFunc: return a fixed decimal point representation of the
  /// Measure object.
  String toStringByFunc(String Function(double) fixFunction) {
    return 'Polar(r: ${fixFunction(radius)}, 𝚹: ${fixFunction(angle)})';
  }
}

class RectRepresentation {
  final dynamic x;
  final dynamic y;

  RectRepresentation(
    this.x,
    this.y,
  );

  @override
  String toString() => 'Rect(x: $x, y: $y)';

  String toStringAsFixed(int precision) {
    String strX = x.toStringAsFixed(precision);
    String strY = y.toStringAsFixed(precision);
    return 'Rect(x: $strX, y: $strY)';
  }

  /// toStringByFunc: return a fixed decimal point representation of the
  /// Measure object.
  String toStringByFunc(String Function(double) fixFunction) {
    return 'Rect(x: ${fixFunction(x)}, y: ${fixFunction(y)})';
  }
}
