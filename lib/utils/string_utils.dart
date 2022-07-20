import 'package:word/utils/data_utils.dart';
import 'package:word/word/word.dart';

extension StringUtils on String {

  String toCamelCase() {
    return this[0].toUpperCase() + substring(1);
  }
}

int getWordOfTodayIndex([int otherNumber = -1]) {
  if (otherNumber == -1) {
    if (number < words.length) return number;
    var temp = number;
    while (temp >= words.length) {
      temp -= words.length;
    }
    return temp;
  } else {
    if (otherNumber < words.length) return otherNumber;
    var temp = otherNumber;
    while (temp >= words.length) {
      temp -= words.length;
    }
    return temp;
  }
}