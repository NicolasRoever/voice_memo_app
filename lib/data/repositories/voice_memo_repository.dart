import 'package:sqflite/sqflite.dart';
import '../services/local_database_service.dart';
import '../../domain/models/voice_memo.dart';

class VoiceMemoRepository {
  final _dbService = LocalDatabaseService();

  Future<void> insertVoiceMemo(VoiceMemo memo) async {
    final db = await _dbService.database;
    await db.insert(
      LocalDatabaseService.tableVoiceMemos,
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<VoiceMemo>> fetchAllVoiceMemos() async {
    final db = await _dbService.database;
    final result = await db.query(LocalDatabaseService.tableVoiceMemos);

    return result.map((map) => VoiceMemo.fromMap(map)).toList();
  }

  Future<void> deleteVoiceMemo(int id) async {
    final db = await _dbService.database;
    await db.delete(
      LocalDatabaseService.tableVoiceMemos,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
