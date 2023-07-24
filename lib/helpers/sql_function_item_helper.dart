import '../classes/Item.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createItemTable(Database database) async {
    await database.execute('''CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    function TEXT,
    name TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )''');
  }

  static Future<Database> db() async {
    return openDatabase('mock.db', version: 1,
        onCreate: (Database database, int version) async {
      await createItemTable(database);
    });
  }

  static Future<int> createItem(Item item) async {
    final db = await SQLHelper.db();
    final id = await db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems(String function) async {
    final db = await SQLHelper.db();

    return db.query('items',
        orderBy: "id", where: "function = ?", whereArgs: [function]);
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();

    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(Item item) async {
    final db = await SQLHelper.db();

    final result = await db
        .update('items', item.toMap(), where: "id = ?", whereArgs: [item.id]);

    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("ST wrong : $err");
    }
  }
}
