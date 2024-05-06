import 'dart:math' as math;

import 'measure_functions.dart';

/// Define a operation not allowed exception
class OperationNotAllowed implements Exception {
  final Object? err;
  OperationNotAllowed([this.err]);
  String error() {
    if (err != null) {
      return "ERROR: operation in measure class isn't allowed ($err)";
    }
    return "ERROR: operation in measure class isn't allowed";
  }
}

/// This class represents a measure with a value attribute for the
/// operational measure and delta attribute for the measure deviation.
class Measure {
  final double value;
  final double delta;

  /// Measure: default constructor.
  Measure([this.value = 0, this.delta = 0]);

  /// Measure.fromString: declaration of constructor to build a measure from
  /// a string entry in format 'value'±'delta'.
  factory Measure.fromString(String str) {
    try {
      final strSplit = str.split('±');
      final sValue = strSplit[0];
      final sDelta = strSplit[1];
      return Measure(double.parse(sValue), double.parse(sDelta));
    } catch (err) {
      throw OperationNotAllowed(err);
    }
  }

  static Measure? tryParse(String text) {
    try {
      RegExp regExp = RegExp(r'(-?\d*\.?\d+(e[+\-]?\d+)?)');

      final matches = regExp.allMatches(text.replaceAll(' ', '')).toList();

      if (matches.length != 2) return null;

      final value = double.parse(matches[0].group(0) ?? '');
      final delta = double.parse(matches[1].group(0) ?? '');

      return Measure(value, delta);
    } catch (err) {
      return null;
    }
  }

  /// operator +: declaration of the sum operation.
  Measure operator +(Measure other) =>
      Measure(value + other.value, delta + other.delta);

  /// operator -: declaration of the subtraction operation.
  Measure operator -(Measure other) =>
      Measure(value - other.value, delta + other.delta);

  /// operation *: declaration of the multiplication operation between
  /// measures and measure for double value.
  Measure operator *(dynamic other) {
    if (other is Measure) {
      final double r = value * other.value;
      return Measure(
          r, r.abs() * (delta / value.abs() + other.delta / other.value.abs()));
    } else if (other is num) {
      return Measure(value * other.toDouble(), delta * other.toDouble().abs());
    } else {
      throw OperationNotAllowed();
    }
  }

  /// operator /: declaration of the division operator between
  /// measures and measure and a double value.
  Measure operator /(dynamic other) {
    if (other is Measure) {
      double r = value / other.value;
      return Measure(
          r, r.abs() * (delta / value.abs() + other.delta / other.value.abs()));
    } else if (other is num) {
      return Measure(value / other.toDouble(), delta / other.toDouble().abs());
    } else {
      throw OperationNotAllowed();
    }
  }

  /// operator ==: override the operator ==
  @override
  bool operator ==(Object other) {
    if (other is Measure) {
      return (other.runtimeType == runtimeType) &&
          (other.value == value) &&
          (other.delta == delta);
    }
    return false;
  }

  /// get hashCode: this override is required for correct implementation
  /// of override of the operator ==
  @override
  int get hashCode => value.hashCode;

  bool equivalence(dynamic other) {
    final higher = value + delta;
    final lower = value - delta;
    if (other is Measure) {
      final otherH = other.value + other.delta;
      final otherL = other.value - other.delta;
      final deltaOHH = otherH - higher;
      final deltaOHL = otherH - lower;
      final deltaHOL = higher - otherL;
      final deltaLOL = lower - otherL;
      return (deltaOHH > 0 && deltaOHL > 0 && deltaHOL < 0 && deltaLOL < 0) ||
              (deltaOHH < 0 && deltaOHL < 0 && deltaHOL > 0 && deltaLOL > 0)
          ? false
          : true;
    } else {
      if (other is num) {
        return (higher < other.toDouble()) || (lower > other.toDouble())
            ? false
            : true;
      } else {
        throw OperationNotAllowed();
      }
    }
    // return true;
  }

  /// toString: override of the function toString to return a better
  /// representation of the Measure object.
  @override
  String toString() {
    return '($value±$delta)';
  }

  /// toStringAsFixed: return a fixed decimal point representation of the
  /// Measure object.
  String toStringAsFixed(int fix) {
    return '(${value.toStringAsFixed(fix)}±${delta.toStringAsFixed(fix)})';
  }

  /// toStringByFunc: return a fixed decimal point representation of the
  /// Measure object.
  String toStringByFunc(String Function(double) fixFunction) {
    return '(${fixFunction(value)}±${fixFunction(delta)})';
  }

  /// truncate: return a truncated representation of the Measure object.
  String truncate() {
    final int n = getOrder(delta);

    if (n >= 0) {
      if (value.abs() > 1) {
        return '${value.toStringAsFixed(n)}±${delta.toStringAsFixed(n)}';
      } else {
        final int m = getOrder(value);
        return '(${(value * mathPow10(m.toDouble())).toStringAsFixed(n - m)}±'
            '${(delta * mathPow10(m.toDouble())).toStringAsFixed(n - m)})E${-m}';
      }
    } else {
      return '(${(value * mathPow10(n.toDouble())).toStringAsFixed(0)}±'
          '${(delta * mathPow10(n.toDouble())).toStringAsFixed(0)})E${-n}';
    }
  }

  bool isApproximatelyEqual(Measure m1, [int magnitude = -6]) {
    final tolerance = math.pow(10, magnitude).toDouble();
    final relativeDifferenceValue = ((value - m1.value) / value).abs();
    final relativeDifferenceDelta = ((delta - m1.delta) / value).abs();

    return (relativeDifferenceValue <= tolerance) &&
        (relativeDifferenceDelta <= tolerance);
  }
}
