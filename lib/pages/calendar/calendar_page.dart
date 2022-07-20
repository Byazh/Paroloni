import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:word/pages/home/home_page.dart';
import 'package:word/utils/data_utils.dart';
import 'package:word/utils/string_utils.dart';
import 'package:word/word/word.dart';

import '../../main.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

const months = ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"];

class _CalendarPageState extends State<CalendarPage> {

  DateTime _selected = DateTime.now();

  late String word;
  late String pronunciation;
  late String grammaticalFunction;
  late String definition;
  late String examples;
  late String synonyms;
  late String link;

  @override
  void initState() {
    // Prendo la parola dalla lista json e assegno i valori alle variabili
    super.initState();
  }

  void setWord({required String word, required pronunciation, required grammaticalFunction, required definition, required examples, required synonyms, required link}) {
    this.word = word;
    this.pronunciation = pronunciation;
    this.grammaticalFunction = grammaticalFunction;
    this.definition = definition;
    this.examples = examples;
    this.synonyms = synonyms;
    this.link = link;
  }

  @override
  Widget build(BuildContext context) {
    var a = words[words.keys.elementAt(getWordOfTodayIndex(_selected.difference(DateTime(2022, 1, 1)).inDays))];
    setWord(word: a["w"], pronunciation: a["p"], grammaticalFunction: a["g"], definition: a["d"], examples: a["e"], synonyms: a["s"],  link: a["l"]);
    final theme = Theme.of(context);
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
        title: Column(
          children: [
            Text(
              months[ _selected.month - 1],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  fontSize: height / 48
              ),
            ),
            Text(
              _selected.year.toString(),
              style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 54
              ),
            ),
          ],
        )
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: height / 30, left: width / 20, right: width / 20),
            child: TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2022, 12, 31),
              focusedDay: _selected,
              currentDay: _selected,
              calendarFormat: CalendarFormat.month,
              headerVisible: false,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date1, date2) {
                setState(() {
                  _selected = date1;
                });
              },
              onPageChanged: (date) {
                setState(() {
                  _selected = date;
                });
              },
              calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: height / 50,
                  ),
                  todayDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle
                  ),
                  todayTextStyle: TextStyle(
                      fontSize: height / 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                  weekendTextStyle: TextStyle(
                      fontSize: height / 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                  rangeStartTextStyle: TextStyle(
                      fontSize: height / 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                  outsideTextStyle: TextStyle(
                      fontSize: height / 50,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400
                  ),
                  markerDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                  )
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: height / 50,
                  ),
                  weekendStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: height / 50,
                  )
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 20),
              width: width,
              height: height / 3.5,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(220, 48, 40, 1.0),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 10
                  )
                ]
              ),
              child: GestureDetector(
                onTap: () {
                  number = words.keys.toList().indexOf(word);
                  numberChanged.value = !numberChanged.value;
                  numberChanged.notifyListeners();
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 17, vertical: height / 20),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                      stops: [0.85, 1.0],
                    ).createShader(bounds),
                    blendMode: BlendMode.dstOut,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Text(
                            word,
                            style: TextStyle(
                                fontSize: height / 19,
                                color: Colors.white,
                                height: 1,
                                fontWeight: FontWeight.w800
                            )
                        ),

                        Text(
                            pronunciation,
                            style: TextStyle(
                                fontSize: height / 31,
                                color: theme.accentColor.withOpacity(0.8),
                                fontWeight: FontWeight.w500
                            )
                        ),
                        if (grammaticalFunction != "") Text(
                            grammaticalFunction,
                            style: TextStyle(
                                fontSize: height / 36,
                                color: theme.accentColor.withOpacity(0.54),
                                fontWeight: FontWeight.w400
                            )
                        ),
                        SizedBox(
                            height: height / 45
                        ),
                        Text(
                            definition,
                            style: TextStyle(
                                fontSize: height / 35,
                                color: theme.accentColor.withOpacity(0.9),
                                fontWeight: FontWeight.w500
                            )
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
          )
        ],
      )
    );
  }
}
