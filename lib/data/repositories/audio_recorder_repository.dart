import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import '../../domain/models/voice_memo.dart';
import '../../data/services/audio_recorder_service.dart';
import '../../data/services/local_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioRecorderRepository {
  final AudioRecorderService _service;
  final VoiceMemoDatabase _db;

  AudioRecorderRepository(this._service, this._db);

  Future<String> _generateRecordingPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'recording_$timestamp.m4a';
    return join(dir.path, fileName);
  }

  Future<VoiceMemo> start() async {
    final fullPath = await _generateRecordingPath();
    await _service.startRecording(fullPath: fullPath);
    return VoiceMemo(path: fullPath, createdAt: DateTime.now());
  }

  Future<VoiceMemo?> stop() async {
    final filePath = await _service.stopRecording();
    if (filePath != null) {
      final memo = VoiceMemo(path: filePath, createdAt: DateTime.now());
      await _db.insertMemo(memo);
      return memo;
    }
    return null;
  }

  Future<List<VoiceMemo>> fetchAll() async {
    return await _db.fetchAllMemos();
  }

  Future<bool> isRecording() async => await _service.isRecording();
}

// Inline provider
final audioRecorderRepositoryProvider = Provider<AudioRecorderRepository>((ref) {
  final service = AudioRecorderService();
  final db = VoiceMemoDatabase();
  return AudioRecorderRepository(service, db);
});
