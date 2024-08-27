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

// ignore_for_file: public_member_api_docs, sort_constructors_first
class KeyModel {
  final String label;
  final int offset;

  KeyModel({
    required this.label,
    this.offset = 1,
  });

  factory KeyModel.fromLabel(String label) {
    int index = label.indexOf('(');
    int offset = (index != -1 && label.length > 1) ? index + 1 : label.length;

    return KeyModel(label: label, offset: offset);
  }

  @override
  String toString() => 'KeyModel(label: $label, offset: $offset)';
}
