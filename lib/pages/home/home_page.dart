import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:word/main.dart';
import 'package:word/utils/data_utils.dart';
import 'package:word/utils/string_utils.dart';
import 'package:word/file/file.dart';
import 'package:word/word/word.dart';

ValueNotifier numberChanged = ValueNotifier(false);

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late String word;
  late String pronunciation;
  late String grammaticalFunction;
  late String definition;
  late String examples;
  late String synonyms;
  late String link;

  late bool favourite;

  late Animation<double> animation;
  late AnimationController controller;

  /// Used to prevent page from fade animating when user adds or removes word
  /// from favourites

  bool changedFavourite = false;

  @override
  void initState() {
    // Setup fading animation at the beginning and at every refresh
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000)
    );
    animation = Tween(
        begin: 0.0,
        end: 1.0
    ).animate(controller);
    // Setup word of the day
    final word = words[words.keys.elementAt(getWordOfTodayIndex())];
    setWord(
        word: word["w"],
        pronunciation: word["p"],
        grammaticalFunction: word["g"],
        definition: word["d"],
        examples: word["e"],
        synonyms: word["s"],
        link: word["l"]
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!changedFavourite) {
      controller
        ..reset()
        ..forward();
    }
    final listController = ScrollController();
    changedFavourite = false;
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: numberChanged,
      builder: (context, value, child) {
        final w = words[words.keys.elementAt(getWordOfTodayIndex())];
        final date = DateTime(2022, 1, 1).add(Duration(days: number));
        setWord(
            word: w["w"],
            pronunciation: w["p"],
            grammaticalFunction: w["g"],
            definition: w["d"],
            examples: w["e"],
            synonyms: w["s"],
            link: w["l"]
        );
        return Container(
          color: theme.scaffoldBackgroundColor,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Builder(
                builder: (context) {
                  return  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: height / 20,
                      color: theme.accentColor
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer()
                  );
                }
              ),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: width / 25),
                      child: Text(
                        "${date.day}/${date.month}/${date.year}",
                        style: TextStyle(
                          fontSize: height / 51,
                          color: Colors.white70
                        )
                      )
                    )
                  ]
                )
              ]
            ),
            drawer: SizedBox(
              width: width / 2,
              child: Drawer(
                backgroundColor: const Color.fromRGBO(220, 48, 40, 1.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height / 10
                    ),
                    const DrawerElement(
                      icon: Icons.text_fields,
                      title: "Parole",
                      page: "words"
                    ),
                    SizedBox(
                      height: height / 25
                    ),
                    const DrawerElement(
                      icon: Icons.star,
                      title: "Preferiti",
                      page: "favourites"
                    ),
                    SizedBox(
                      height: height / 25
                    ),
                    const DrawerElement(
                      icon: Icons.calendar_today,
                      title: "Calendario",
                      page: "calendar"
                    ),
                    SizedBox(
                        height: height / 25
                    ),
                   const DrawerElement(
                     icon: Icons.settings,
                     title: "Impostazioni",
                     page: "settings"
                   )
                  ]
                )
              )
            ),
            body: FadeTransition(
              opacity: animation,
              child: Center(
                child: Container(
                  width: width / 1.3,
                  height: height / 1.4,
                  margin: EdgeInsets.only(bottom: height / 8),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                      stops: [0.0, 0.15, 0.85, 1.0],
                    ).createShader(bounds),
                    blendMode: BlendMode.dstOut,
                    child: ListView(
                      controller: listController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        /// So that the word title isn't affected by the top shader mask
                        SizedBox(
                          height: height / 12
                        ),
                        Text(
                          word,
                          style: TextStyle(
                            fontSize: height / 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1
                          )
                        ),
                        SizedBox(
                          height: height / 55
                        ),
                        Text(
                          pronunciation,
                          style: TextStyle(
                            fontSize: height / 31,
                            color: theme.accentColor.withOpacity(0.9),
                            fontWeight: FontWeight.w500
                          )
                        ),
                        SizedBox(
                          height: height / 200
                        ),
                        if (grammaticalFunction != "") Text(
                          grammaticalFunction,
                          style: TextStyle(
                            fontSize: height / 36,
                            color: theme.accentColor.withOpacity(0.55),
                            fontWeight: FontWeight.w400
                          )
                        ),
                        SizedBox(
                          height: height / 35
                        ),
                        Text(
                          definition,
                          style: TextStyle(
                            fontSize: height / 32,
                            color: theme.accentColor,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        if (examples != "") SizedBox(
                          height: height / 35
                        ),
                        if (examples != "") Text(
                          examples,
                          style: TextStyle(
                            fontSize: height / 39,
                            color: theme.accentColor.withOpacity(0.70),
                            fontWeight: FontWeight.w400
                          )
                        ),
                        if (synonyms != "") SizedBox(
                          height: height / 55
                        ),
                        if (synonyms != "") Text(
                          synonyms,
                          style: TextStyle(
                            fontSize: height / 39,
                            color: theme.accentColor.withOpacity(0.70),
                            fontWeight: FontWeight.w400
                          )
                        ),
                        SizedBox(
                          height: height / 35
                        ),
                        GestureDetector(
                          child: Text(
                            "($link)",
                            style: TextStyle(
                              fontSize: height / 60,
                               color: theme.accentColor.withOpacity(0.8),
                               fontWeight: FontWeight.w700
                            )
                          ),
                          onTap: () {
                            launchUrlString(link);
                          },
                        ),
                        SizedBox(
                            height: height / 15
                        ),
                      ]
                    )
                  )
                )
              )
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    favourite ? Icons.star : Icons.star_border,
                    size: height / 22,
                    color: favourite ? Colors.yellow : theme.accentColor
                  ),
                  onPressed: () {
                    setState(() {
                      if (favourite) {
                        favourite = false;
                        favourites.remove(word);
                      } else {
                        favourite = true;
                        favourites.add(word);
                      }
                      USER_DATA.write(jsonEncode({
                        "lastAccess": lastAccess,
                        "favourites": favourites,
                        "nHour": notificationHour,
                        "nMinute": notificationMinute,
                        "version": version
                      }));
                      changedFavourite = true;
                    });
                  }
                ),
                Container(
                  margin: EdgeInsets.only(bottom: height / 60),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(246, 104, 94, 1),
                    radius: height / 23,
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: height / 22,
                        color: theme.accentColor
                      ),
                      onPressed: () {
                        setState(() {
                          listController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.linearToEaseOut);
                          number = Random().nextInt(words.length - 1);
                        });
                      }
                    )
                  )
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    size: height / 22,
                    color: theme.accentColor
                  ),
                  onPressed: () {
                    /// TODO: Create widget with word of the day and render it as a picture
                  }
                )
              ]
            )
          )
        );
      }
    );
  }

  void setWord({required String word, required pronunciation, required grammaticalFunction, required definition, required examples, required synonyms, required link}) {
    this.word = word;
    this.pronunciation = pronunciation;
    this.grammaticalFunction = grammaticalFunction;
    this.definition = definition;
    this.examples = examples;
    this.synonyms = synonyms;
    this.link = link;
    favourite = favourites.contains(word);
  }
}

class DrawerElement extends StatelessWidget {

  final IconData icon;
  final String title;
  final String page;

  const DrawerElement({Key? key, required this.icon, required this.title, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        size: height / 22,
        color: theme.accentColor
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: height / 42,
          color: theme.accentColor,
          fontWeight: FontWeight.w600
        )
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, page);
      }
    );
  }
}

