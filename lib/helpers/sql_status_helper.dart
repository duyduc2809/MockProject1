import 'package:mock_prj1/helpers/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../models/status.dart';

class SQLStatusHelper {
  static Future<void> createStatusTable(Database database) async {
    await database.execute('''CREATE TABLE status(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    userId INTEGER,
    name TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )''');
  }

  static Future<int> createStatus(Status status) async {
    final db = await DatabaseHelper.db();
    final id = await db.insert('status', status.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getStatuses(int? userId) async {
    final db = await DatabaseHelper.db();

    return db.query(
      'status',
      orderBy: "id",
      where: " userID = ?",
      whereArgs: [userId],
    );
  }

  static Future<List<Map<String, dynamic>>> getStatus(int id) async {
    final db = await DatabaseHelper.db();

    return db.query('status', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<bool> checkValidStatus(String input) async {
    final db = await DatabaseHelper.db();
    List<Map<String, dynamic>> result =
        await db.query('status', where: "name = ?", whereArgs: [input]);
    return !result.isNotEmpty;
  }

  static Future<int> updateStatus(Status status) async {
    final db = await DatabaseHelper.db();

    final result = await db.update('status', status.toMap(),
        where: "id = ?", whereArgs: [status.id]);

    return result;
  }

  static Future<void> deleteStatus(int id) async {
    final db = await DatabaseHelper.db();

    try {
      await db.delete("status", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("ST wrong : $err");
    }
  }
}
