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
  'rec(r,𝚹)',
  'pol(x,y)',
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
  'pol()',
  'rec()',
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
  'pol',
  'rec',
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
