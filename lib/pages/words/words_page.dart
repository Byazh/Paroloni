import 'package:flutter/material.dart';

import 'package:word/main.dart';
import 'package:word/pages/home/home_page.dart';
import 'package:word/utils/data_utils.dart';
import 'package:word/word/word.dart';
import 'package:word/utils/string_utils.dart';

class WordsPage extends StatefulWidget {

  const WordsPage({Key? key}) : super(key: key);

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                }
            );
          }
        ),
        centerTitle: true,
        title: Text(
          "Parole",
          style: TextStyle(
              fontSize: height / 48,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1
          )
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(false)
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: width / 27),
              child: Icon(
                Icons.search,
                size: height / 30,
                color: Colors.white
              )
            ),
          )
        ]
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
        child: ShaderMask(
          shaderCallback: (Rect bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
            stops: [0.0, 0.07, 0.93, 1.0],
          ).createShader(bounds),
          blendMode: BlendMode.dstOut,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = wordsAlphabetically.values.elementAt(index);
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(
                      top: index == 0 ? height / 21 : 0,
                      bottom: index == 8 ? height / 21 : 0,
                      left: width / 25,
                      right: width / 25
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Text(
                              word["w"].toString().toCamelCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              "   ${word["p"]}",
                              style: TextStyle(
                                  fontSize: height / 56,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w400
                              ),
                            )
                          ],
                        ),
                        subtitle: Text(
                          word["d"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8)
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: height / 40),
                        child: Container(
                          width: width * 0.8,
                          height: 1,
                          color: Colors.white24,
                        )
                      )
                    ]
                  )
                ),
                onTap: () {
                  number = words.keys.toList().indexOf(word["w"]);
                  numberChanged.value = !numberChanged.value;
                  numberChanged.notifyListeners();
                  Navigator.pop(context);
                },
              );
            }
          )
        )
      )
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {

  final bool favourite;

  CustomSearchDelegate(this.favourite);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: const Color.fromRGBO(170, 46, 37, 1),
      scaffoldBackgroundColor: const Color.fromRGBO(170, 46, 37, 1),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      ), // cursor color
        fontFamily: "Euclid",
      textTheme: const TextTheme(
        headline6: TextStyle(
          color: Colors.white
        )
      ),
      hintColor: Colors.white54
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
       icon: const Icon(
            Icons.clear
        ),
        onPressed: () {
         query = "";
        },

      )
    ];
  }

  @override
  String get searchFieldLabel => 'Cerca';

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var queried;
    if (!favourite) {
      queried = wordsAlphabetically.keys.where((element) => element.contains(query.toLowerCase())).map((e) => words[e]);
    } else {
      queried = favourites.where((element) => element.contains(query.toLowerCase()));
    }
    return Container(
        margin: EdgeInsets.only(top: height / 73.2),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(220, 48, 40, 1.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(height / 21),
                topRight: Radius.circular(height / 21)
            )
        ),
        child: ShaderMask(
            shaderCallback: (Rect bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
              stops: [0.0, 0.07, 0.93, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.dstOut,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: queried.length,
                itemBuilder: (context, index) {
                  final word = favourite ? words[queried.elementAt(index)] : queried.elementAt(index);
                  return Container(
                      margin: EdgeInsets.only(
                          top: index == 0 ? height / 21 : 0,
                          bottom: index == 8 ? height / 21 : 0,
                          left: width / 25,
                          right: width / 25
                      ),
                      child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    word["w"].toString().toCamelCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    "   ${word["p"]}",
                                    style: TextStyle(
                                        fontSize: height / 56,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w400
                                    ),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                word["d"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8)
                                ),
                              ),
                            ),
                            if (index != 8) Container(
                                margin: EdgeInsets.symmetric(vertical: height / 40),
                                child: Container(
                                  width: width * 0.8,
                                  height: 1,
                                  color: Colors.white24,
                                )
                            )
                          ]
                      )
                  );
                }
            )
        )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var queried;
    if (!favourite) {
      queried = wordsAlphabetically.keys.where((element) => element.contains(query.toLowerCase())).map((e) => words[e]);
    } else {
      queried = favourites.where((element) => element.contains(query.toLowerCase()));
    }return Container(
        margin: EdgeInsets.only(top: height / 73.2),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(220, 48, 40, 1.0),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(height / 21),
                topRight: Radius.circular(height / 21)
            )
        ),
        child: ShaderMask(
            shaderCallback: (Rect bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
              stops: [0.0, 0.07, 0.93, 1.0],
            ).createShader(bounds),
            blendMode: BlendMode.dstOut,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: queried.length,
                itemBuilder: (context, index) {
                  final word = favourite ? wordsAlphabetically[queried.elementAt(index)] : queried.elementAt(index);
                  return Container(
                      margin: EdgeInsets.only(
                          top: index == 0 ? height / 21 : 0,
                          bottom: index == 8 ? height / 21 : 0,
                          left: width / 25,
                          right: width / 25
                      ),
                      child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    word["w"].toString().toCamelCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    "   ${word["p"]}",
                                    style: TextStyle(
                                        fontSize: height / 56,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w400
                                    ),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                word["d"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8)
                                ),
                              ),
                            ),
                            if (index != 8) Container(
                                margin: EdgeInsets.symmetric(vertical: height / 40),
                                child: Container(
                                  width: width * 0.8,
                                  height: 1,
                                  color: Colors.white24,
                                )
                            )
                          ]
                      )
                  );
                }
            )
        )
    );
  }
}