import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:word/file/file.dart';
import 'package:word/pages/words/words_page.dart';
import 'package:word/utils/data_utils.dart';
import 'package:word/utils/string_utils.dart';
import 'package:word/word/word.dart';

import '../../main.dart';

class FavouritesPage extends StatefulWidget {

  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {

  @override
  Widget build(BuildContext context) {
    favourites.sort();
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
            },
          ),
        centerTitle: true,
        title: Text(
          "Preferiti",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            fontSize: height / 48
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(true)
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
        ],
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
            itemCount: favourites.isEmpty ? 1 : favourites.length + 1,
            itemBuilder: (context, index) {
              if (favourites.isEmpty) {
                return Container(
                  margin: EdgeInsets.only(top: height / 3.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book,
                          color: Colors.white70,
                          size: height / 10,
                        ),
                        Text(
                            "\nNon hai ancora aggiunto alcuna\nparola ai tuoi preferiti",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: height / 44
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (index == 0) return SizedBox(height: height / 21,);
              final word = words[favourites.elementAt(index - 1)];
              return Dismissible(
                key: Key(word["w"]),
                onDismissed: (a) {
                  favourites.remove(word["w"]);
                  USER_DATA.write(jsonEncode({
                    "lastAccess": lastAccess,
                    "favourites": favourites,
                    "nHour": notificationHour,
                    "nMinute": notificationMinute,
                    "version": version
                  }));
                },
                //background: Container(color: Color.fromRGBO(187, 24, 17, 1.0)),
                child: Container(
                  margin: EdgeInsets.only(
                      top: 0,
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
                              )
                            ),
                            Text(
                              "  ${word["p"]}",
                              style: TextStyle(
                                fontSize: height / 56,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400
                              )
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
                        ),
                      )
                    ]
                  )
                ),
              );
            }
          )
        )
      )
    );
  }
}
