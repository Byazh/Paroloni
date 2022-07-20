import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word/file/file.dart';
import 'package:word/notifications/notifications.dart';
import 'package:word/utils/data_utils.dart';
import 'package:word/word/word.dart';

import '../../main.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool notifications = true;

  bool edited = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        if (!edited) return true;
        USER_DATA.write(jsonEncode({
          "lastAccess": DateTime.now().millisecondsSinceEpoch,
          "favourites": favourites,
          "nHour": notificationHour,
          "nMinute": notificationMinute,
          "version": version
        }));
        scheduleFutureNotifications();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) {
              return  IconButton(
                  icon: Icon(
                      Icons.arrow_back_rounded,
                      size: height / 30,
                      color: Colors.white
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (!edited) return;
                    USER_DATA.write(jsonEncode({
                      "lastAccess": DateTime.now().millisecondsSinceEpoch,
                      "favourites": favourites,
                      "nHour": notificationHour,
                      "nMinute": notificationMinute,
                      "version": version
                    }));
                    scheduleFutureNotifications();
                  }
              );
            },
          ),
          centerTitle: true,
          title: Text(
            "Impostazioni",
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                fontSize: height / 48
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: height / 73.2),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(220, 48, 40, 1.0),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(height / 21),
                  topRight: Radius.circular(height / 21)
              )
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.only(left: width / 30, right: width / 30, top: height / 20),
                child: Column(
                  children: [
                    /*
                    ListTile(
                        title: Text(
                          "Tema",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: height / 46
                          ),
                        ),
                        subtitle: Text(
                          "Scegli il tema e i colori che preferisci per questa app!",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                              fontSize: height / 52
                          ),
                        )
                    ),
                    SizedBox(height: height / 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width / 6 ,
                          height: height / 12,
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                          ),
                        ),
                        Container(
                          width: width / 6 ,
                          height: height / 12,
                          color: Colors.yellow,
                        ),
                        Container(
                          width: width / 6 ,
                          height: height / 12,
                          color: Colors.blue,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: height / 30,
                          ),
                        ),
                        Container(
                          width: width / 6 ,
                          height: height / 12,
                          color: Colors.pink,
                        ),
                        Container(
                          width: width / 6 ,
                          height: height / 12,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: height / 30, horizontal: width / 10),
                      height: 1,
                      width: width * 0.8,
                      color: Colors.white24,
                    ),*/
                    ListTile(
                      title: Text(
                        "Notifiche",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: height / 46
                        ),
                      ),
                      subtitle: Text(
                        "Vuoi ricevere notifiche giornaliere con la parola del giorno?",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                            fontSize: height / 52
                        ),
                      ),
                      trailing: CupertinoSwitch(
                        onChanged: (bool value) async {
                          setState(() {
                            notifications = !notifications;
                            if (notifications == true) {
                              scheduleFutureNotifications();
                            } else {
                              flutterLocalNotificationsPlugin.cancelAll();
                            }
                          });
                        },
                        value: notifications
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: height / 30, horizontal: width / 10),
                      height: 1,
                      width: width * 0.8,
                      color: Colors.white24,
                    ),
                    ListTile(
                        title: Text(
                          "Orario notifica",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: height / 46
                          ),
                        ),
                        subtitle: Text(
                          "A che ora vuoi ricevere la notifica ogni giorno?",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                              fontSize: height / 52
                          ),
                        )
                    ),
                    SizedBox(
                      height: height / 5,
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                          brightness: Brightness.dark
                        ),
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime(1, 1, 2022, notificationHour, notificationMinute),
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (DateTime value) async {
                            notificationHour = value.hour;
                            notificationMinute = value.minute;
                            edited = true;
                          }
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
