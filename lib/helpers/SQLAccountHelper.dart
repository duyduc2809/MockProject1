import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/Account.dart';

class SQLAccountHelper {
  static const _accountsTable = 'accounts';
  static const _columnId = 'id';
  static const _columnEmail = 'email';
  static const _columnPassword = 'password';
  static const _columnCreateAt = 'createAt';
  static const _accountPath = 'accounts.db';

  static Future<void> createAccountTable(Database database) async {
    await database.execute('''CREATE TABLE $_accountsTable(
    $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnEmail TEXT NOT NULL, 
    $_columnPassword TEXT NOT NULL, 
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
    final db = await SQLAccountHelper.db();
    final id = await db.insert(_accountsTable, account.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await SQLAccountHelper.db();

    return db.query(_accountsTable, orderBy: _columnId);
  }

  static Future<List<Map<String, dynamic>>> getAccount(int id) async {
    final db = await SQLAccountHelper.db();

    return db.query(_accountsTable,
        where: "$_columnId = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateAccount(Account account) async {
    final db = await SQLAccountHelper.db();

    final result = await db.update(_accountsTable, account.toMap(),
        where: "$_columnId = ?", whereArgs: [account.id]);
    return result;
  }

  static Future<void> deleteAccount(int id) async {
    final db = await SQLAccountHelper.db();

    try {
      await db.delete(_accountsTable, where: "$_columnId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an account: $err");
    }
  }
}