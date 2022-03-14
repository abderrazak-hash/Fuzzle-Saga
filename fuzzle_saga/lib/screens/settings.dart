import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'
    show AnimatedTextKit, TypewriterAnimatedText;

import 'package:fuzzle_saga/main.dart';
import 'package:fuzzle_saga/quizzes/quizzes.dart';
import 'package:fuzzle_saga/utils/utils.dart';

class FuzzleSettings extends StatefulWidget {
  const FuzzleSettings({Key? key}) : super(key: key);

  @override
  _FuzzleSettingsState createState() => _FuzzleSettingsState();
}

class _FuzzleSettingsState extends State<FuzzleSettings> {
  bool reset = false;
  Row option(String opt, int) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100.0,
          child: Text(
            opt,
            style: TextStyle(
              fontSize: 21.0,
              color: textMode,
            ),
          ),
        ),
        SizedBox(width: 15.0),
        GestureDetector(
          onTap: () {
            setState(() {
              if (opt == 'Sound') {
                setState(() {
                  settings[1]['sound'] = settings[1]['sound'] == 0 ? 1 : 0;
                });
                FuzzleDB.changeSound(settings[1]['sound']!);
              } else if (opt == 'Darkness') {
                setState(() {
                  settings[2]['dark'] = settings[2]['dark'] == 0 ? 1 : 0;
                  darkMode = settings[2]['dark'] == 1 ? darkBlue : Colors.white;
                  textMode = settings[2]['dark'] == 0 ? darkBlue : Colors.white;
                  borderMode = settings[2]['dark'] == 0 ? blue : Colors.white;
                });
                FuzzleDB.changeMode(settings[2]['dark']!);
              }
            });
          },
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: textMode,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: (opt == 'Sound' && settings[1]['sound'] == 1) ||
                    (opt == 'Darkness' && settings[2]['dark'] == 1)
                ? Center(
                    child: Icon(
                    Icons.check,
                    color: textMode,
                  ))
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        // No route is found
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FuzzleGame()));
        return true;
      },
      child: Scaffold(
        backgroundColor: darkMode,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset('assets/dashatar.png'),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                            TypewriterAnimatedText('Settings',
                                speed: Duration(milliseconds: 500), cursor: ''),
                          ],
                          totalRepeatCount: 5000,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(50.0),
                    height: 180.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.blue.withOpacity(0.1),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          option('Sound', 0),
                          SizedBox(height: 10),
                          option('Darkness', 1),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70.0,
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 21.0,
                                    color: textMode,
                                  ),
                                ),
                              ),
                              SizedBox(width: 30.0),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    reset = true;
                                  });
                                },
                                color: textMode,
                                icon: Icon(
                                  Icons.replay,
                                  size: 30.0,
                                  color: textMode,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (reset)
              Center(
                child: Container(
                  height: 130.0,
                  width: 220.0,
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    top: 10.0,
                  ),
                  margin: EdgeInsets.all(50.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                          child: Text(
                        'Are You sure you want to reset the game?',
                        textAlign: TextAlign.center,
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                FuzzleDB.reset();
                                setState(() {
                                  FuzzleGame.getDatum();
                                  reset = false;
                                });
                              },
                              child: Text('YES')),
                          SizedBox(width: 15.0),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  reset = false;
                                });
                              },
                              child: Text('No',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
