import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import '../../domain/models/voice_memo.dart';
import '../../data/services/audio_recorder_service.dart';
import '../../data/services/local_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioRecorderRepository {
  final AudioRecorderService _service;
  final VoiceMemoDatabase _db;
  final AudioPlayer _player = AudioPlayer();

  String? _currentlyPlaying;

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
      print('✅ Memo saved: $filePath');
      return memo;
    }
    print('⚠️ Recording stopped but no file returned.');
    return null;
  }

  Future<void> togglePlayback(String path) async {
    print('🎧 togglePlayback: $path');

    if (_currentlyPlaying == path && _player.playing) {
      print('⏹️ Stopping playback');
      await _player.stop();
      _currentlyPlaying = null;
    } else {
      print('▶️ Starting playback');
      _currentlyPlaying = path;
      await _player.setFilePath(path);
      await _player.play();

      // Optional: auto-reset when done
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _currentlyPlaying = null;
        }
      });
    }

    print('📍 currentlyPlaying: $_currentlyPlaying');
  }

  String? get currentlyPlaying => _currentlyPlaying;

  void dispose() { _player.dispose(); }


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
