import 'package:sqflite/sqflite.dart';
import 'package:top_news/services/database_helper.dart';

class Repository {
  late DbHelper _dbHelper;

  Repository() {
    _dbHelper = DbHelper();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _dbHelper.setDatabase();
      return _database;
    }
  }

  // Insert data to the table
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  // Read data from the table
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  // Update data in the table
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'url = ?', whereArgs: [data['url']]);
  }

  // Delete data from the table
  deleteData(String table, String url) async {
    final connection = await database;
    return await connection?.delete(
      table,
      where: 'url = ?',
      whereArgs: [url],
    );
  }
}
