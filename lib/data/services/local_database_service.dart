import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/models/voice_memo.dart';

class VoiceMemoDatabase {
  static final VoiceMemoDatabase _instance = VoiceMemoDatabase._internal();
  factory VoiceMemoDatabase() => _instance;

  VoiceMemoDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'voice_memos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE voice_memos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertMemo(VoiceMemo memo) async {
    final db = await database;
    return await db.insert('voice_memos', memo.toMap());
  }

  Future<List<VoiceMemo>> fetchAllMemos() async {
    final db = await database;
    final maps = await db.query('voice_memos', orderBy: 'createdAt DESC');
    return maps.map((map) => VoiceMemo.fromMap(map)).toList();
  }
}
