import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../classes/Note.dart';
import 'sql_account_helper.dart';

class SQLNoteHelper{
  static late Map<String, dynamic> currentNote;
  static const _notesTable = 'notes';
  static const _columnNoteId = 'id';
  static const _columnNoteName = 'name';
  static const _columnCategoryName = 'categoryName';
  static const _columnPriorityName = 'priorityName';
  static const _columnStatusName = 'statusName';
  static const _columnPlanDate = 'planDate';
  static const _columnCreateAt = 'createdAt';
  static const _columnAccountId = 'accountId';

  static Future<void> createNotesTable(Database database) async {
  await database.execute('''CREATE TABLE $_notesTable(
    $_columnNoteId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_columnNoteName TEXT NOT NULL,
    $_columnCategoryName TEXT NOT NULL,
    $_columnPriorityName TEXT NOT NULL,
    $_columnStatusName TEXT NOT NULL,
    $_columnPlanDate TEXT NOT NULL,
    $_columnCreateAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    $_columnAccountId INTEGER NOT NULL,
    FOREIGN KEY ($_columnAccountId) REFERENCES ${SQLAccountHelper.accountsTable}(${SQLAccountHelper.columnId}) 
      ON DELETE CASCADE ON UPDATE NO ACTION
  )''');
}
  static Future<Database> db() async {
  return openDatabase(
    'account.db',
    version: 2, // Thay đổi version từ 1 thành 2
    onCreate: (Database database, int version) async {
      // Enable foreign key support
      await database.execute("PRAGMA foreign_keys = ON;");
      await createNotesTable(database);
    },
    onUpgrade: (Database database, int oldVersion, int newVersion) {
      // Thực hiện các thay đổi trong cơ sở dữ liệu khi có sự thay đổi version
      if (oldVersion < 2) {
        // Thêm cột id với tự động tăng
        database.execute('''ALTER TABLE $_notesTable
          ADD COLUMN $_columnNoteId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
        ''');
      }
    },
  );
}

static Future<int> createNote(Note note) async {
    final db = await SQLNoteHelper.db();
    
    // Thêm thông tin accountId vào map của ghi chú
    final noteMap = note.toMap();
    noteMap[_columnAccountId] = note.accountId;
    
    final id = await db.insert(
      _notesTable,
      noteMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

static Future<List<Map<String, dynamic>>> getNotes({int? accountId}) async {
  final db = await SQLNoteHelper.db();
  final List<Map<String, dynamic>> maps = await db.query(
    _notesTable,
    where: '$_columnAccountId = ?', 
    whereArgs: [accountId], 
  );

  return maps;
}

  static Future<Map<String, dynamic>?> getNoteById(int id) async {
  final db = await SQLNoteHelper.db();
  final List<Map<String, dynamic>> maps = await db.query(
    _notesTable,
    where: '$_columnNoteId = ?',
    whereArgs: [id],
  );
  if (maps.isNotEmpty) {
    return maps[0];
  } else {
    return null;
  }
}

  static Future<int> updateNote(Note note) async {
    final db = await SQLNoteHelper.db();
    final result = await db.update(
      _notesTable,
      note.toMap(),
      where: '$_columnNoteId = ?',
      whereArgs: [note.id],
    );
    return result;
  }

  static Future<void> deleteNote(int id) async {
    final db = await SQLNoteHelper.db();
    await db.delete(
      _notesTable,
      where: '$_columnNoteId = ?',
      whereArgs: [id],
    );
  }
}