import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fuzzle_saga/main.dart';

import 'package:fuzzle_saga/utils/utils.dart';
import 'package:fuzzle_saga/screens/fuzzle_play.dart';

class FuzzleSaga extends StatefulWidget {
  final int page;
  FuzzleSaga({required this.page});
  @override
  _FuzzleSagaState createState() => _FuzzleSagaState();
}

class _FuzzleSagaState extends State<FuzzleSaga> {
  Container levelGate(int level) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                levels[level - 1]['stars']! >= 2
                    ? Icons.star
                    : Icons.star_border,
                color: levels[level - 1]['stars']! >= 2 ? gold : blue,
                size: 18.0,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  levels[level - 1]['stars']! >= 1
                      ? Icons.star
                      : Icons.star_border,
                  color: levels[level - 1]['stars']! >= 1 ? gold : blue,
                  size: 25.0,
                ),
              ),
              Icon(
                levels[level - 1]['stars'] == 3
                    ? Icons.star
                    : Icons.star_border,
                color: levels[level - 1]['stars'] == 3 ? gold : blue,
                size: 18.0,
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              if (level <= currentLevel) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FuzzlePlay(level: level)),
                );
              } else {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: darkMode,
                    title: Icon(
                      Icons.lock,
                      color: blue,
                      size: 35.0,
                    ),
                    content: Container(
                      height: 30.0,
                      child: Center(
                        child: Text(
                          'Level Locked!',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: level <= currentLevel
                    ? Text(
                        level.toString(),
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.lock,
                        size: 35.0,
                        color: blue,
                      ),
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: level <= currentLevel && settings[2]['dark'] == 0
                  ? blue
                  : level <= currentLevel && settings[2]['dark'] == 1
                      ? darkMode
                      : level > currentLevel && settings[2]['dark'] == 0
                          ? Colors.white
                          : darkMode,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: level <= currentLevel ? Colors.white : blue,
                  width: 3.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  late int page;

  @override
  void initState() {
    super.initState();
    page = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkMode,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: textMode,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    // No route is found
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FuzzleGame()));
                  },
                ),
                Container(
                  width: 190.0,
                  child: Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: textMode,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('Fuzzle Saga',
                              speed: Duration(milliseconds: 500), cursor: ''),
                        ],
                        totalRepeatCount: 5000,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40.0,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.0),
              margin: EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text(
                    'Select Level',
                    style: TextStyle(
                      color: blue,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (line) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (col) => levelGate(9 * page + 3 * line + col + 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: page > 0
                            ? () {
                                setState(() {
                                  page--;
                                });
                              }
                            : null,
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: page > 0 ? 2.0 : 0.5,
                              color: page > 0 ? textMode : Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: textMode,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 60.0,
                        child: Center(
                          child: Text(
                            (page * 9 + 1).toString() +
                                ' - ' +
                                ((page + 1) * 9).toString(),
                            style: TextStyle(
                              color: textMode,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: page < 2
                            ? () {
                                setState(() {
                                  page++;
                                });
                              }
                            : null,
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: page < 2 ? 2.0 : 0.5,
                              color: page < 2 ? textMode : Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: textMode,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
