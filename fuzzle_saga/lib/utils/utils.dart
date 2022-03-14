import 'package:flutter/material.dart';

Color blue = Color(0xFF0468d7),
    darkBlue = Color(0xFF041e3c),
    lightBlue = Color(0xFF027dfd),
    gold = Colors.yellow;

late int currentLevel;
Color? darkMode; //  = settings[2]['dark'] == 1 ? darkBlue : Colors.white;
late List<Map<String, dynamic>> levels;
late List<Map<String, int>> settings;

Color textMode = settings[2]['dark'] == 0 ? darkBlue : Colors.white;
Color borderMode = settings[2]['dark'] == 1 ? blue : Colors.white;
