import 'package:sqflite/sqflite.dart';
import '../classes/note.dart';
import 'database_helper.dart';
import 'sql_account_helper.dart';

class SQLNoteHelper {
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

  static Future<Map<String, double>> getStat(int userId) async {
    final db = await DatabaseHelper.db();
    var result = await db.rawQuery(
        'SELECT $_columnStatusName, $_columnAccountId, COUNT(*) as count FROM $_notesTable GROUP BY $_columnStatusName, $_columnAccountId');
    print(result);
    Map<String, double> resultMap = {};
    for (var item in result) {
      Object? statusName = item['statusName'];
      Object? count = item['count'];
      resultMap[statusName.toString()] = double.parse(count.toString());
    }
    print(resultMap);
    return resultMap;
  }

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

  static Future<int> createNote(Note note) async {
    final db = await DatabaseHelper.db();

    // Thêm thông tin accountId vào map của ghi chú
    final noteMap = note.toMap();
    noteMap[_columnAccountId] = note.accountId;

    final id = await db.insert(
      _notesTable,
      noteMap,conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getNotes({int? accountId}) async {
    final db = await DatabaseHelper.db();
    final List<Map<String, dynamic>> maps = await db.query(
      _notesTable,
      where: '$_columnAccountId = ?',
      whereArgs: [accountId],
    );

    return maps;
  }

  static Future<Map<String, dynamic>?> getNoteById(int id) async {
    final db = await DatabaseHelper.db();
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
    final db = await DatabaseHelper.db();
    final result = await db.update(
      _notesTable,
      note.toMap(),
      where: '$_columnNoteId = ?',
      whereArgs: [note.id],
    );
    return result;
  }

  static Future<void> deleteNote(int id) async {
    final db = await DatabaseHelper.db();
    await db.delete(
      _notesTable,
      where: '$_columnNoteId = ?',
      whereArgs: [id],
    );
  }
}