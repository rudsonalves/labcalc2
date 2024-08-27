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

import 'package:flutter/material.dart';

import '../../constants/buttons_label.dart';
import 'memory.dart';

const List<String> memoriesLabels = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  ansLabel,
];

class AppMemories {
  AppMemories._();
  static final _instance = AppMemories._();
  static AppMemories instante = _instance;

  final Map<String, Memory> _memories = {};
  Map<String, Memory> get memories => _memories;

  final storageOn$ = ValueNotifier<bool>(false);
  bool get storageOn => storageOn$.value;

  void toogleStorageOn() {
    storageOn$.value = !storageOn$.value;
  }

  void init() {
    resetMemories();
  }

  void resetMemories() {
    _memories.clear();
    _memories.addEntries(
      memoriesLabels.map(
        (element) => MapEntry(element, Memory(0)),
      ),
    );
  }

  dynamic getValue(String label) => _memories[label]!.value;
  void setValue(String label, dynamic value) => _memories[label]!.value = value;

  dynamic get mAns => _memories[ansLabel]!.value;
  set mAns(dynamic value) => _memories[ansLabel]!.value = value;

  dynamic get mA => _memories['A']!.value;
  set mA(dynamic value) => _memories['A']!.value = value;

  dynamic get mB => _memories['B']!.value;
  set mB(dynamic value) => _memories['B']!.value = value;

  dynamic get mC => _memories['C']!.value;
  set mC(dynamic value) => _memories['C']!.value = value;

  dynamic get mD => _memories['D']!.value;
  set mD(dynamic value) => _memories['D']!.value = value;

  dynamic get mE => _memories['E']!.value;
  set mE(dynamic value) => _memories['E']!.value = value;

  dynamic get mF => _memories['F']!.value;
  set mF(dynamic value) => _memories['F']!.value = value;

  dynamic get mG => _memories['G']!.value;
  set mG(dynamic value) => _memories['G']!.value = value;

  dynamic get mH => _memories['H']!.value;
  set mH(dynamic value) => _memories['H']!.value = value;

  dynamic get mXm => _memories[xmLabel]!.value;
  set mXm(dynamic value) => _memories[xmLabel]!.value = value;

  @override
  String toString() {
    String stringValue = 'Memories: ';
    for (String label in _memories.keys) {
      stringValue += '$label: ${getValue(label)}  ';
    }
    return stringValue.trim();
  }
}
