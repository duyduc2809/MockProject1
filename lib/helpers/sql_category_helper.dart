import 'package:mock_prj1/helpers/database_helper.dart';

import '../classes/Category.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class SQLCategoryHelper {
  static Future<void> createCategoryTable(Database database) async {
    await database.execute('''CREATE TABLE category(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    userId INTEGER,
    name TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )''');
  }

  static Future<int> createCategory(Category category) async {
    final db = await DatabaseHelper.db();
    final id = await db.insert('category', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getCategories(int? userId) async {
    final db = await DatabaseHelper.db();

    return db.query(
      'category',
      orderBy: "id",
      where: " userID = ?",
      whereArgs: [userId],
    );
  }

  static Future<List<Map<String, dynamic>>> getCategory(int id) async {
    final db = await DatabaseHelper.db();

    return db.query('category', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateCategory(Category category) async {
    final db = await DatabaseHelper.db();

    final result = await db.update('category', category.toMap(),
        where: "id = ?", whereArgs: [category.id]);

    return result;
  }

  static Future<void> deleteCategory(int id) async {
    final db = await DatabaseHelper.db();

    try {
      await db.delete("category", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("ST wrong : $err");
    }
  }
}
