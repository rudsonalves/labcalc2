import 'dart:math';

import '../../constants/constants.dart';
import '../../singletons/app_settings.dart';
import 'measure.dart';

bool isRadian() {
  return AppSettings.instance.isRadians;
}

/*
Statistical functions
*/
/// Return a Measure mean and deviation using a mean and
/// a deviation mathematical models.
Measure calculateXm(List<double> xs) {
  final mean = AppSettings.instance.mean;
  final deviation = AppSettings.instance.deviation;

  double xm;
  double dxm;

  switch (mean) {
    case TypeMean.arithmetic:
      xm = arithmeticMean(xs);
      break;
    case TypeMean.harmonic:
      xm = harmonicMean(xs);
      break;
    case TypeMean.rms:
      xm = rmsMean(xs);
      break;
    default:
      throw OperationNotAllowed();
  }

  switch (deviation) {
    case TypeDeviation.meanDeviation:
      dxm = simpleMeaDeviation(xs, xm);
      break;
    case TypeDeviation.sampleStdDeviation:
      dxm = sampleStandardDeviation(xs, xm);
      break;
    case TypeDeviation.popStdDeviation:
      dxm = popsStandardDeviation(xs, xm);
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
  return sqrt(s / xs.length);
}

/// Return a deviation using a Simple Mean Deviation model.
double simpleMeaDeviation(List<double> xs, double xm) {
  return xs.map((xi) => (xm - xi).abs()).reduce((a, b) => a + b) / xs.length;
}

/// Return a deviation using a Sample Standard Deviation model.
double sampleStandardDeviation(List<double> xs, double xm) {
  return sqrt(xs.map((xi) => pow((xm - xi), 2)).reduce((a, b) => a + b)) /
      (xs.length - 1);
}

/// Return a deviation using a Population Standard Deviation model.
double popsStandardDeviation(List<double> xs, double xm) {
  return sqrt(xs.map((xi) => pow((xm - xi), 2)).reduce((a, b) => a + b)) /
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

/// This function tries to parse the element to a double,
/// otherwise it tries to parse map[element] to a double. If none of the parses
/// are successful a log message is issued and the function return null.
// dynamic dynamicStringParse(String element, Map<String, dynamic> map) {
//   try {
//     return double.parse(element);
//   } on FormatException {
//     if (map.keys.contains(element)) {
//       return map[element];
//     }
//     return element;
//   } catch (err) {
//     dev.log('!!!!!!!!!!!!!Check this ERROR: $err - element: $element');
//     return null;
//   }
// }

/*
Math functions of class Measure
*/
Measure measureAbs(Measure m) {
  return Measure(m.value.abs(), m.delta);
}

Measure measurePow(Measure m, double n) {
  final double r = pow(m.value, n).toDouble();
  return Measure(r, (r * n * m.delta / m.value).abs());
}

Measure measureSqrt(Measure m) {
  final double r = sqrt(m.value);
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
  final double s0 = sin(v0);
  final double s1 = sin(v1);
  // Checks by the derivative if the function
  // is in a range of maximum/minimum
  if (cos(v0) * cos(v1) < 0) {
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
  final double s0 = cos(v0);
  final double s1 = cos(v1);
  // Checks by the derivative if the function
  // is in a range of maximum/minimum
  if (sin(v0) * sin(v1) < 0) {
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
  return measureFunction(m, tan);
}

Measure measureLn(Measure m) {
  return measureFunction(m, log);
}

Measure measureLog(Measure m) {
  return measureFunction(m, log10);
}

Measure measureAcos(Measure m) {
  return measureFunction(m, acos);
}

Measure measureAsin(Measure m) {
  return measureFunction(m, asin);
}

Measure measureAtan(Measure m) {
  return measureFunction(m, atan);
}

Measure measureExp(Measure m) {
  return measureFunction(m, exp);
}

Measure measurePow10(Measure m) {
  return measureFunction(m, pow10);
}

/*
 Some functions
*/
double log10(double value) {
  return log(value) / log(10);
}

double abs(double value) {
  return value.abs();
}

double pow10(double value) {
  return pow(10, value).toDouble();
}

/* ---------------------------------------
 Generics functions return values according
 to the input parameters

 Basics operations
*/
/// Return A + B
dynamic numAdd(dynamic A, dynamic B) {
  if (((A is Measure) && (B is num)) || ((A is num) && (B is Measure))) {
    throw OperationNotAllowed();
  }
  return A + B;
}

/// Return A - B
dynamic numSub(dynamic A, dynamic B) {
  if (((A is Measure) && (B is num)) || ((A is num) && (B is Measure))) {
    throw OperationNotAllowed();
  }
  return A - B;
}

/// Return A*B
dynamic numMult(dynamic A, dynamic B) {
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
dynamic numDiv(dynamic A, dynamic B) {
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
dynamic numAbs(dynamic value) {
  if (value is Measure) {
    return measureAbs(value);
  } else if (value is num) {
    return abs(value.toDouble());
  } else {
    throw OperationNotAllowed();
  }
}

/// This function returns the natural logarithm of a Measure/double of an
/// argument value
dynamic numLn(dynamic value) {
  if (value is Measure) {
    return measureLn(value);
  } else if (value is num) {
    return log(value);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function returns the logarithm base 10 of a Measure/double of an argument value
dynamic numLog(dynamic value) {
  if (value is Measure) {
    return measureLog(value);
  } else if (value is num) {
    return log10(value.toDouble());
  } else {
    throw OperationNotAllowed();
  }
}

/// This function returns the power of 'p' of a Measure/double of an argument value
dynamic numPow(dynamic value, double p) {
  if (value is Measure) {
    return measurePow(value, p);
  } else if (value is num) {
    return pow(value, p);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 1/p of a Measure/double of an argument value
dynamic numPowi(dynamic value, double p) {
  if (value is Measure) {
    return measurePow(value, 1 / p);
  } else if (value is num) {
    return pow(value, 1 / p);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 2 of a Measure/double of an argument value
dynamic numPow2(dynamic value) {
  if (value is Measure) {
    return measurePow(value, 2);
  } else if (value is num) {
    return pow(value, 2);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 3 of a Measure/double of an argument value
dynamic numPow3(dynamic value) {
  if (value is Measure) {
    return measurePow(value, 3);
  } else if (value is num) {
    return pow(value, 3);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 1/3 of a Measure/double of an argument value
dynamic numPowi3(dynamic value) {
  if (value is Measure) {
    return measurePow(value, 1 / 3.0);
  } else if (value is num) {
    return pow(value, 1 / 3.0);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the power 10 of a Measure/double of an argument value
dynamic numPow10(dynamic value) {
  if (value is Measure) {
    return measurePow10(value);
  } else if (value is num) {
    return pow10(value.toDouble());
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the exponent of a Measure/double of an argument value
dynamic numExp(dynamic value) {
  if (value is Measure) {
    return measureExp(value);
  } else if (value is num) {
    return exp(value);
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the square root of a Measure/double of an argument value
dynamic numSqrt(dynamic value) {
  if (value is Measure) {
    return measureSqrt(value);
  } else if (value is num) {
    return sqrt(value);
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
      case sin:
        return measureSin(value);
      case cos:
        return measureCos(value);
      case tan:
        return measureTan(value);
      default:
        throw OperationNotAllowed();
    }
  } else if (value is num) {
    if (func == sin || func == cos || func == tan) {
      return func(value.toDouble());
    } else {
      throw OperationNotAllowed();
    }
  } else {
    throw OperationNotAllowed();
  }
}

/// This function return the cosine of a Measure/double of an argument value in degree
dynamic numCos(dynamic value) {
  return _trigonometricFunction(value, cos);
}

/// This function return the sine of a Measure/double of an argument value in degree
dynamic numSin(dynamic value) {
  return _trigonometricFunction(value, sin);
}

/// This function return the tangent of a Measure/double of an argument value in degree
dynamic numTan(dynamic value) {
  return _trigonometricFunction(value, tan);
}

dynamic _trigonometricInverseFunction(dynamic value, Function func) {
  late dynamic angle;
  if (value is Measure) {
    switch (func) {
      case asin:
        angle = measureAsin(value);
        break;
      case acos:
        angle = measureAcos(value);
        break;
      case atan:
        angle = measureAtan(value);
        break;
      default:
        throw OperationNotAllowed();
    }
  } else if (value is num) {
    if ([asin, acos, atan].contains(func)) {
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
dynamic numAcos(dynamic value) {
  return _trigonometricInverseFunction(value, acos);
}

/// This function return the arc-sine in degree of a Measure/double of an argument value
dynamic numAsin(dynamic value) {
  return _trigonometricInverseFunction(value, asin);
}

/// This function return the arc-tangent in degree of a Measure/double of an argument value
dynamic numAtan(dynamic value) {
  return _trigonometricInverseFunction(value, atan);
}
