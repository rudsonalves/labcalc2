// Constants

/// Mean constants
enum TypeMean { arithmetic, harmonic, rms }

/// Deviation constants
enum TypeDeviation { meanDeviation, sampleStdDeviation, popStdDeviation }

Map<TypeMean, String> meanSignature = {
  TypeMean.arithmetic: 'Arith',
  TypeMean.harmonic: 'Harm',
  TypeMean.rms: 'RMS',
};

Map<TypeDeviation, String> deviationSignature = {
  TypeDeviation.meanDeviation: 'SimDev',
  TypeDeviation.sampleStdDeviation: 'StdDev',
  TypeDeviation.popStdDeviation: 'PopDev',
};

const List<String> removalSeq = [
  'powy(x,y)',
  'log10(x)',
  'asin(x)',
  'acos(x)',
  'atan(x)',
  'pow3(x)',
  'sqr3(x)',
  'sqry(x)',
  'log10()',
  '(x±dx)',
  'abs(x)',
  'log(x)',
  'sin(x)',
  'cos(x)',
  'tan(x)',
  'pow(x)',
  'exp(x)',
  'sqr(x)',
  'asin()',
  'acos()',
  'atan()',
  'pow3()',
  'powy()',
  'sqr3()',
  'sqry()',
  'ln(x)',
  'abs()',
  'log()',
  'sin()',
  'cos()',
  'tan()',
  'pow()',
  'exp()',
  'sqr()',
  'log10',
  'ln()',
  'asin',
  'acos',
  'atan',
  'pow3',
  'powy',
  'sqr3',
  'sqry',
  'exp',
  'sqr',
  'abs',
  'log',
  'sin',
  'cos',
  'tan',
  'pow',
  'ANS',
  '(x)',
  'ln',
  '()',
  'EE',
  'dx',
];
