import 'package:animated_text_kit/animated_text_kit.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:audioplayers/audio_cache.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:math' show Random;

import 'package:fuzzle_saga/utils/utils.dart';
import 'package:fuzzle_saga/screens/fuzzle_saga.dart';
import 'package:fuzzle_saga/quizzes/quizzes.dart';

class FuzzlePlay extends StatefulWidget {
  final int level;
  FuzzlePlay({required this.level});
  @override
  _FuzzlePlayState createState() => _FuzzlePlayState();
}

class _FuzzlePlayState extends State<FuzzlePlay> {
  late List<List<String>> fuzzle;
  late String solution, code;
  late int a, b, moves, tile, stars, stage;
  late double width, tileWidth;

  // or as a local variable
  static final player = AudioCache();

  // call this method when desired
  static void play() {
    if (settings[1]['sound'] == 1) {
      player.play('move.wav', mode: PlayerMode.LOW_LATENCY);
    }
  }

  void winFuzzle() {
    if (widget.level == currentLevel) {
      setState(() {
        currentLevel++;
      });
      FuzzleDB.updateLevel(widget.level);
    }
    stars = moves < 50 * (stage - 2)
        ? 3
        : moves < 100 * (stage - 2)
            ? 2
            : moves < 150 * (stage - 2)
                ? 1
                : 0;
    if (stars > levels[widget.level - 1]['stars']) {
      setState(() {
        levels[widget.level - 1]['stars'] = stars;
      });
      FuzzleDB.updateStars(solution, stars);
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkMode,
        title: Text(
          'Congrats',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: blue,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    createFuzzle();
                  });
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.replay,
                  size: 35.0,
                  color: lightBlue,
                  semanticLabel: 'Shuffle',
                ),
              ),
              IconButton(
                onPressed: widget.level < 27
                    ? () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FuzzlePlay(level: widget.level + 1)));
                      }
                    : null,
                icon: Icon(
                  Icons.arrow_forward,
                  size: 35.0,
                  color: lightBlue,
                  semanticLabel: 'next',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void testFuzzle() {
    int i = 1, j = 0, k = 0;
    tile = stage * stage - 1;
    code = '';
    while (i < stage * stage) {
      if (fuzzle[j][k] == solution[i - 1]) {
        tile--;
        code += solution[i - 1];
      } else {
        if (solution[i - 1] != ' ') {
          code += '*';
        }
      }
      if (i % stage == 0) {
        k = 0;
        j++;
      } else {
        k++;
      }
      i++;
    }
  }

  void playFuzzle(int x, int y) {
    setState(() {
      if (x == a) {
        play();
        moves++;
        if (y < b) {
          int i = b;
          while (i > y) {
            fuzzle[x][i] = fuzzle[x][--i];
          }
        } else if (y > b) {
          int i = b;
          while (i < y) {
            fuzzle[x][i] = fuzzle[x][++i];
          }
        }
        fuzzle[x][y] = '';
        b = y;
      } else if (y == b) {
        play();
        moves++;
        if (x < a) {
          int i = a;
          while (i > x) {
            fuzzle[i][y] = fuzzle[--i][y];
          }
        } else if (x > a) {
          int i = a;
          while (i < x) {
            fuzzle[i][y] = fuzzle[++i][y];
          }
        }
        fuzzle[x][y] = '';
        a = x;
      }
    });
    testFuzzle();
    if (tile == 0) {
      winFuzzle();
    }
  }

  void createFuzzle() {
    solution = levels[widget.level - 1]['answer'];
    int x, y;
    moves = 0;
    int i;
    do {
      fuzzle =
          List.generate(stage, (index) => List.generate(stage, (index) => ''));
      i = 0;
      while (i < stage * stage - 1) {
        x = Random().nextInt(stage);
        y = Random().nextInt(stage);
        if (fuzzle[x][y] == '') {
          // I was using while here
          fuzzle[x][y] = solution[i++];
        }
      }
      testFuzzle();
    } while (tile != stage * stage - 1);
    b = -1;
    i = 0;
    while (b == -1) {
      b = fuzzle[i].indexOf('');
      a = i++;
    }
  }

  TextButton tileFuzzle(int x, int y) {
    return TextButton(
      onPressed: (x != a || y != b)
          ? () {
              playFuzzle(x, y);
            }
          : null,
      child: Container(
        height: tileWidth,
        width: tileWidth,
        child: Center(
          child: Text(
            fuzzle[x][y],
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: fuzzle[x][y] != '' ? blue : darkMode,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: darkMode!,
            width: 3.0,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      player.clearCache();
      stage = widget.level <= 9 ? 3 : 4;
      createFuzzle();
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    tileWidth = width / 4 - 12;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Navigator.pop(context);
          // No route is found
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FuzzleSaga(page: (currentLevel - 1) ~/ 9)));
          return true;
        },
        child: Scaffold(
          backgroundColor: darkMode,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 30.0,
              ),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FuzzleSaga(page: (widget.level - 1) ~/ 9)));
                    },
                  ),
                  Column(
                    children: [
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
                                    speed: Duration(milliseconds: 500),
                                    cursor: ''),
                              ],
                              totalRepeatCount: 5000,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        moves.toString() +
                            ' Moves | ' +
                            tile.toString() +
                            ' Tiles',
                        style: TextStyle(
                          color: blue,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 40.0),
                ],
              ),
              SizedBox(height: 15.0),
              Text(
                levels[widget.level - 1]['question'] + ' ?',
                style: TextStyle(
                  fontSize: 16.0,
                  color: textMode,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Container(
                width: 230.0,
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 3.0,
                    color: textMode,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        code,
                        style: TextStyle(
                          color: textMode,
                          fontSize: stage == 3 ? 25 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            String currentState = code;
                            code = solution.replaceAll(' ', '');
                            Future.delayed(Duration(seconds: 2)).then((value) {
                              setState(() {
                                code = currentState;
                              });
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.lock,
                            size: 20.0,
                            color: textMode,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(stage == 4 ? 24.0 : 30.0),
                height: width,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    stage,
                    (line) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(stage, (col) => tileFuzzle(line, col)),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    createFuzzle();
                  });
                },
                child: Container(
                  width: 105.0,
                  height: 20.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.replay,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      Center(
                        child: Text(
                          'Shuffle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
