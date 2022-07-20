import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:word/utils/string_utils.dart';
import 'package:word/word/word.dart';

import '../utils/data_utils.dart';

NotificationDetails platformChannelSpecifics = const NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics
);

const AndroidNotificationDetails androidPlatformChannelSpecifics =
AndroidNotificationDetails(
    "12345",
    "focus_app",
    channelDescription: "App to focus",
    playSound: false,
    importance: Importance.max,
    priority: Priority.max
);

const IOSNotificationDetails iOSPlatformChannelSpecifics =
IOSNotificationDetails(
    presentAlert: true,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentBadge: false,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentSound: false
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("@drawable/ic_launcher");

    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: true
    );
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

void scheduleFutureNotifications() async {
  flutterLocalNotificationsPlugin.cancelAll();
  var today = DateTime.now();
  var numberOfWords = words.length;
  var numberTemp = DateTime.now().difference(DateTime(2022, 1 ,1)).inDays;
  initializeTimeZones();
  FlutterNativeTimezone.getLocalTimezone().then((value) async {
    for (int i = 0; i <= 25; i++) {
      if (numberTemp >= numberOfWords) {
        numberTemp = 0;
      }
      final temp = today.add(Duration(days: i));
      final nextDay = DateTime(temp.year, temp.month, temp.day, notificationHour, notificationMinute);
      var seconds = nextDay.difference(today).inSeconds;
      var date = TZDateTime.from(today, getLocation(value)).add(Duration(seconds: seconds));
      if (date.isAfter(today)) {
        flutterLocalNotificationsPlugin.zonedSchedule(
            i,
            words.keys.elementAt(getWordOfTodayIndex(numberTemp)),
            words.values.elementAt(getWordOfTodayIndex(numberTemp))["d"],
            date,
            platformChannelSpecifics,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true
        );
        numberTemp++;
      }
    }
  });
}