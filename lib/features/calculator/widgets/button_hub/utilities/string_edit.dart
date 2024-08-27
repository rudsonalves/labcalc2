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

import '../../../../../common/constants/constants.dart';
import '../../../../../common/models/key_model/key_model.dart';

/// class specialized in editing the display string
class StringEdit {
  StringEdit._();

  static String removeLastCharacter(text, position) {
    return text.substring(0, position - 1) + text.substring(position);
  }

  static (String?, int) tryRemoveSpecialSequence(String text, int position) {
    for (String seq in removalSeq) {
      int seqLength = seq.length;

      int startPos = position - seqLength;
      startPos = startPos < 0 ? 0 : startPos;

      int endPos = position + (seqLength - 1);
      endPos = endPos > text.length ? text.length : endPos;

      String subString = text.substring(startPos, endPos);

      if (subString.contains(seq)) {
        int offset = subString.indexOf(seq);

        text = text.substring(0, offset + startPos) +
            text.substring(offset + startPos + seqLength);
        position = offset + startPos;
        return (text, position);
      }
    }
    return (null, -1);
  }

  static String insertAtCurrentPosition(
    int endPositionSelection,
    String text,
    KeyModel key,
  ) {
    if (endPositionSelection == text.length) {
      text += key.label;
    } else {
      text = text.substring(0, endPositionSelection) +
          key.label +
          text.substring(endPositionSelection, text.length);
    }
    return text;
  }

  static String insertAtSelectionPosition(String text,
      int startPositionSelection, KeyModel key, int endPositionSelection) {
    text = text.substring(0, startPositionSelection) +
        key.label +
        text.substring(endPositionSelection, text.length);
    return text;
  }
}
