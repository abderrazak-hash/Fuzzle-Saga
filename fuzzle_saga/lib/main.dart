import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzle_saga/quizzes/quizzes.dart';
import 'package:fuzzle_saga/screens/fuzzle_saga.dart';
import 'package:fuzzle_saga/screens/settings.dart';
import 'package:fuzzle_saga/utils/utils.dart';

import 'package:animated_text_kit/animated_text_kit.dart'
    show AnimatedTextKit, TypewriterAnimatedText;

void main() => runApp(
      MaterialApp(
        home: FuzzleGame(),
        debugShowCheckedModeBanner: false,
      ),
    );


class FuzzleGame extends StatefulWidget {
  const FuzzleGame({Key? key}) : super(key: key);
  static void getDatum() async {
    levels = await FuzzleDB.getQuizzes();
    settings = await FuzzleDB.getSettings();
    currentLevel = settings[0]['currentLevel']!;
    darkMode = settings[2]['dark'] == 1 ? darkBlue : Colors.white;
  }

  @override
  _FuzzleGameState createState() => _FuzzleGameState();
}

class _FuzzleGameState extends State<FuzzleGame> {
  TextButton fuzzleButton(String task, Function toDo) {
    return TextButton(
      onPressed: () {
        toDo();
      },
      child: Container(
        height: 50.0,
        width: 120.0,
        child: Center(
          child: Text(
            task,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: blue,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: Colors.white,
            width: 3.0,
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    FuzzleGame.getDatum();

    Future.delayed(Duration(seconds: 1)).then((value) => (() {
          setState(() {
            darkMode = settings[2]['dark'] == 1 ? darkBlue : Colors.white;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('assets/dashatar.png'),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Fuzzle Saga',
                            speed: Duration(milliseconds: 500),
                            cursor: '',
                          ),
                        ],
                        totalRepeatCount: 5000,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        fuzzleButton('PLAY', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FuzzleSaga(
                                      page: (currentLevel - 1) ~/ 9)));
                        }),
                        SizedBox(width: 15.0),
                        fuzzleButton('SETTINGS', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FuzzleSettings()));
                        }),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    fuzzleButton('EXIT', () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    }),
                    SizedBox(height: 50.0),
                  ],
                ),
                SizedBox(),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'All Rights Reserved',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
