import 'package:mock_prj1/helpers/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../classes/priority.dart';


class SQLPriorityHelper {
  static Future<void> createPriorityTable(Database database) async {
    await database.execute('''CREATE TABLE priority(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    userId INTEGER,
    name TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )''');
  }

  static Future<int> createPriority(Priority priority) async {
    final db = await DatabaseHelper.db();
    final id = await db.insert('priority', priority.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getPriorities(int? userId) async {
    final db = await DatabaseHelper.db();

    return db.query(
      'priority',
      orderBy: "id",
      where: " userID = ?",
      whereArgs: [userId],
    );
  }

  static Future<List<Map<String, dynamic>>> getPriority(int id) async {
    final db = await DatabaseHelper.db();

    return db.query('priority', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updatePriority(Priority priority) async {
    final db = await DatabaseHelper.db();

    final result = await db.update('priority', priority.toMap(),
        where: "id = ?", whereArgs: [priority.id]);

    return result;
  }

  static Future<void> deletePriority(int id) async {
    final db = await DatabaseHelper.db();

    try {
      await db.delete("priority", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("ST wrong : $err");
    }
  }
}
