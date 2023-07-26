import '../classes/Item.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'sql_account_helper.dart';

class SQLHelper {
  static Future<int> createItem(Item item) async {
    final db = await SQLAccountHelper.db();
    final id = await db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems(
      String function, int? userId) async {
    final db = await SQLAccountHelper.db();

    return db.query(
      'items',
      orderBy: "id",
      where: "function = ? AND userID = ?",
      whereArgs: [function, userId],
    );
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLAccountHelper.db();

    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(Item item) async {
    final db = await SQLAccountHelper.db();

    final result = await db
        .update('items', item.toMap(), where: "id = ?", whereArgs: [item.id]);

    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLAccountHelper.db();

    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("ST wrong : $err");
    }
  }
}