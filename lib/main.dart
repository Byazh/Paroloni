import 'package:flutter/material.dart';

import 'package:word/pages/home/home_page.dart';
import 'package:word/pages/splash/splash_page.dart';
import 'package:word/pages/words/words_page.dart';
import 'package:word/pages/favourites/favourites_page.dart';
import 'package:word/pages/calendar/calendar_page.dart';
import 'package:word/pages/settings/settings_page.dart';

import 'package:word/themes/themes.dart';
import 'package:word/utils/data_utils.dart';

late double width, height;

const version = 1.0;

void main() async {
  runApp(const _Application());
}

class _Application extends StatelessWidget {

  const _Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loadData();
    return ValueListenableBuilder<int>(
      valueListenable: theme,
      builder: (context, value, child) {
        return MaterialApp(
          title: "Parola del giorno",
          theme: themes[value],
          routes: {
            "splash": (_) => const SplashPage(),
            "home": (_) => const HomePage(),
            "words": (_) => const WordsPage(),
            "favourites": (_) => const FavouritesPage(),
            "calendar": (_) => const CalendarPage(),
            "settings": (_) => const SettingsPage()
          },
          initialRoute: "splash"
        );
      }
    );
  }
}
