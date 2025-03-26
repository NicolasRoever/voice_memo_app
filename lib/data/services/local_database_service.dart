import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseService {
  static const _dbName = 'voice_memos.db';
  static const _dbVersion = 1;

  static const tableVoiceMemos = 'voice_memos';

  static final LocalDatabaseService _instance = LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;

  LocalDatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableVoiceMemos (
        id INTEGER PRIMARY KEY,
        filePath TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        duration INTEGER NOT NULL
      )
    ''');
  }
}
