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
