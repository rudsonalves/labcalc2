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
