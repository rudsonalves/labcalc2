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

import 'measure_functions.dart';

class Vector {
  final dynamic x;
  final dynamic y;
  final dynamic z;
  bool isRec = true;

  Vector([
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
  ]);

  factory Vector.fromPolar([dynamic radius, dynamic theta, dynamic phi = 0.0]) {
    dynamic x = radius * cos(theta) * cos(phi);
    dynamic y = radius * sin(theta) * cos(phi);
    dynamic z = radius * sin(phi);
    return Vector(x, y, z);
  }

  (dynamic r, dynamic o, dynamic f) toPolar() {
    dynamic radius = sqr(pow(x) + pow(y) + pow(z));
    dynamic phi = asin(radius / z);
    dynamic theta = atan(y / x);
    return (radius, theta, phi);
  }

  @override
  String toString() {
    if (isRec) {
      if (z == 0) {
        return '($x i + $y j)';
      }
      return '($x i + $y j + $z k)';
    } else {
      dynamic radius;
      dynamic theta;
      dynamic phi;
      (radius, theta, phi) = toPolar();
      if (phi == 0) {
        return 'Polar(r: $radius, 𝚹: $theta)';
      }
      return 'Polar(r: $radius, 𝚹: $theta, 𝚽: $phi)';
    }
  }

  Vector operator +(Vector other) =>
      Vector(x + other.x, y + other.y, z + other.z);

  Vector operator -(Vector other) =>
      Vector(x - other.x, y - other.y, z - other.z);

  Vector operator *(Vector other) => Vector(
        y * other.z - z * other.y,
        z * other.x - x * other.z,
        x * other.y - y * other.x,
      );

  dynamic dotProduct(Vector other) => (x * other.x + y * other.y + z * other.z);
}
