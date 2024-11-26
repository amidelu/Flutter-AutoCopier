import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
      ''',
    );
  }

  /// Bulk insert method to insert multiple user entries at once.
  Future<void> insertUsers(List<Map<String, String>> users) async {
    final db = await database;

    // Use a transaction to improve performance.
    await db.transaction((txn) async {
      Batch batch = txn.batch();
      for (var user in users) {
        batch.insert('users', user);
      }
      await batch.commit(noResult: true);  // Improve speed by avoiding result output.
    });
  }
}