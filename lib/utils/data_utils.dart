import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:word/file/file.dart';
import 'package:word/main.dart';
import 'package:word/notifications/notifications.dart';
import 'package:word/word/word.dart';

var number = DateTime.now().difference(DateTime(2022, 1 ,1)).inDays;

var lastAccess = DateTime.now().millisecondsSinceEpoch;

var notificationHour = 0, notificationMinute = 0;

Future<void> loadData() async {
  await NotificationService().init();
  final content1 = await WORDS_FILE.read();
  final file = await rootBundle.loadString('resources/words/parole.json');
  if (content1.contains("{") && content1.contains("}")) {
    words = jsonDecode(content1);
    wordsAlphabetically = jsonDecode(file);
  } else {
    final finalWords = {};
    words = jsonDecode(file);
    wordsAlphabetically = words;
    final wordsShuffled = words.values.toList();
    wordsShuffled.shuffle();
    wordsShuffled.forEach((element) {
      finalWords.putIfAbsent(element["w"], () => element);
    });
    words = finalWords;
    WORDS_FILE.write(jsonEncode(finalWords));
  }
  final content = await USER_DATA.read();
  if (content.contains("{") && content.contains("}")) {
    Map<String, dynamic> decoded = jsonDecode(content);
    favourites = decoded["favourites"];
    lastAccess = decoded["lastAccess"];
    notificationHour = decoded["nHour"];
    notificationMinute = decoded["nMinute"];
    if (newYear(DateTime.fromMillisecondsSinceEpoch(lastAccess), DateTime.now())) scheduleFutureNotifications();
    USER_DATA.write(jsonEncode({
      "lastAccess": DateTime.now().millisecondsSinceEpoch,
      "favourites": favourites,
      "nHour": notificationHour,
      "nMinute": notificationMinute,
      "version": version
    }));
  } else {
    USER_DATA.write(jsonEncode({
      "lastAccess": DateTime.now().millisecondsSinceEpoch,
      "favourites": [],
      "nHour": 9,
      "nMinute": 0,
      "version": version
    }));
    scheduleFutureNotifications();
  }
}

bool datesSameDay(DateTime one, DateTime two) {
  return one.day == two.day && one.month == two.month && one.year == two.year;
}

bool newYear(DateTime one, two) {
  return two.difference(one).inDays > 5;
}