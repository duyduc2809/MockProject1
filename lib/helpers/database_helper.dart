import 'package:mock_prj1/helpers/sql_account_helper.dart';
import 'package:mock_prj1/helpers/sql_category_helper.dart';
import 'package:mock_prj1/helpers/sql_note_helper.dart';
import 'package:mock_prj1/helpers/sql_priority_helper.dart';
import 'package:mock_prj1/helpers/sql_status_helper.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbPath = 'mock.db';

  static Future<Database> db() async {
    return openDatabase(_dbPath, version: 1,
        onCreate: (Database database, int version) async {
      await SQLAccountHelper.createAccountTable(database);
      await SQLCategoryHelper.createCategoryTable(database);
      await SQLPriorityHelper.createPriorityTable(database);
      await SQLStatusHelper.createStatusTable(database);
      await SQLNoteHelper.createNotesTable(database);
    });
  }
}
