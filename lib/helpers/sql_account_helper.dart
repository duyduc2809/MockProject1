import 'package:flutter/material.dart';
import 'package:mock_prj1/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/account.dart';

class SQLAccountHelper {
  static late Map<String, dynamic> currentAccount;
  static const _accountsTable = 'accounts';
  static const _columnId = 'id';
  static const _columnEmail = 'email';
  static const _columnPassword = 'password';
  static const _columnFirstName = 'firstName';
  static const _columnLastName = 'lastName';
  static const _columnCreateAt = 'createAt';
  static const _accountPath = 'mock.db';

  static String get accountsTable => _accountsTable;

  static String get columnId => _columnId;

  static Future<void> createAccountTable(Database database) async {
    await database.execute('''CREATE TABLE $_accountsTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnEmail TEXT NOT NULL, 
    $_columnPassword TEXT NOT NULL, 
    $_columnFirstName TEXT,
    $_columnLastName TEXT,
    $_columnCreateAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  static Future<Database> db() async {
    return openDatabase(_accountPath, version: 1,
        onCreate: (Database database, int version) async {
      await createAccountTable(database);
    });
  }

  //Create new account
  static Future<int> createAccount(Account account) async {
    final db = await DatabaseHelper.db();
    final id = await db.insert(_accountsTable, account.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await DatabaseHelper.db();

    return db.query(_accountsTable, orderBy: _columnId);
  }

  static Future<List<Map<String, dynamic>>> getAccount(int id) async {
    final db = await DatabaseHelper.db();

    return db.query(_accountsTable,
        where: "$_columnId = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateAccount(Account account) async {
    final db = await DatabaseHelper.db();

    final result = await db.update(_accountsTable, account.toMap(),
        where: "$_columnId = ?", whereArgs: [account.id]);
    return result;
  }

  static Future<void> deleteAccount(int id) async {
    final db = await DatabaseHelper.db();

    try {
      await db.delete(_accountsTable, where: "$_columnId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an account: $err");
    }
  }

  static Future<int> saveUser(String email, String password) async {
    var db = await DatabaseHelper.db();
    var value = {'email': email, 'password': password};
    var result = await db.insert(_accountsTable, value);
    return result;
  }

  static Future<Map<String, dynamic>?> getAccountToSave() async {
    var db = await DatabaseHelper.db();
    var result = await db.query(
      _accountsTable,
      columns: [_columnId, _columnEmail, _columnPassword],
    );

    if (result.length > 0) {
      return result.first;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getAccountById(int id) async {
    var db = await DatabaseHelper.db();
    var result = await db.query(
      _accountsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  static setCurrentAccount(TextEditingController emailController) async {
    var db = await DatabaseHelper.db();
    List<Map<String, dynamic>> result = await db.query(
      _accountsTable,
      where: 'email = ?',
      whereArgs: [emailController.text],
    );

    if (result.isNotEmpty) {
      print('${result.first}');
      currentAccount = result.first;
    } else {
      return null;
    }
  }

// static Future<int> createItem(Item item) async {
//   final db = await SQLAccountHelper.db();
//   final id = await db.insert('items', item.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace);

//   return id;
// }

// static Future<List<Map<String, dynamic>>> getItems(String function) async {
//   final db = await SQLAccountHelper.db();

//   return db.query('items',
//       orderBy: "id", where: "function = ?", whereArgs: [function]);
// }

// static Future<List<Map<String, dynamic>>> getItem(int id) async {
//   final db = await SQLAccountHelper.db();

//   return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
// }

// static Future<int> updateItem(Item item) async {
//   final db = await SQLAccountHelper.db();

//   final result = await db
//       .update('items', item.toMap(), where: "id = ?", whereArgs: [item.id]);

//   return result;
// }

// static Future<void> deleteItem(int id) async {
//   final db = await SQLAccountHelper.db();

//   try {
//     await db.delete("items", where: "id = ?", whereArgs: [id]);
//   } catch (err) {
//     debugPrint("ST wrong : $err");
//   }
// }
}
