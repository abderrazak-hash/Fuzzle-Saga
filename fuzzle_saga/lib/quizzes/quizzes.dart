import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:fuzzle_saga/utils/utils.dart';

class FuzzleDB {
  static late Database _database;
  static Future<Database> getData() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "database.db");
    var exist = await databaseExists(dbPath);
    if (!exist) {
      ByteData data = await rootBundle.load("assets/database.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
    return await openDatabase(dbPath);
  }

  static Future<List<Map<String, dynamic>>> getQuizzes() async {
    _database = await getData();
    final List<Map<String, dynamic>> fuzzleQuiz = await _database.query('quiz');
    return List.generate(fuzzleQuiz.length, (i) {
      return {
        'question': fuzzleQuiz[i]['question'],
        'answer': fuzzleQuiz[i]['answer'],
        'stars': fuzzleQuiz[i]['stars'],
      };
    });
  }

  static Future<void> updateStars(String answer, int stars) async {
    _database = await getData();
    _database
        .execute('UPDATE quiz SET stars = "$stars" WHERE answer = "$answer"');
  }

  static Future<List<Map<String, int>>> getSettings() async {
    _database = await getData();
    final settings = await _database.query('settings');
    return List.generate(
        settings.length,
        (i) => {
              settings[i]['option'].toString():
                  int.parse(settings[i]['value'].toString()),
            });
  }

  static updateLevel(int level) async {
    _database = await getData();
    _database.execute(
        'UPDATE "settings" SET "value" = "$currentLevel" WHERE "option" = "currentLevel"');
  }

  static void reset() async {
    _database = await getData();
    _database.execute('UPDATE quiz SET stars = "0"');
    _database.execute(
        'UPDATE "settings" SET "value" = "1" WHERE "option" = "currentLevel"');
    _database
        .execute('UPDATE "settings" SET "value" = "0" WHERE "option" = "dark"');

    _database.execute(
        'UPDATE "settings" SET "value" = "1" WHERE "option" = "sound"');
  }

  static void changeMode(int val) async {
    _database = await getData();
    _database.execute(
        'UPDATE "settings" SET "value" = "$val" WHERE "option" = "dark"');
  }

  static void changeSound(int val) async {
    _database = await getData();
    _database.execute(
        'UPDATE "settings" SET "value" = "$val" WHERE "option" = "sound"');
  }
}
