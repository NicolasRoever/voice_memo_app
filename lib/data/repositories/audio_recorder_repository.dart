import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/services/shared_preferences_service.dart';
import '../../domain/models/voice_memo.dart';
import '../../data/services/audio_recorder_service.dart';
import '../../data/services/local_database_service.dart';
import '../../data/services/supabase_service.dart';
import '../../providers/shared_providers.dart';

class AudioRecorderRepository {
  final AudioRecorderService _service;
  final VoiceMemoDatabase _db;
  final SupabaseService _supabaseService;
  final SharedPreferencesService _prefs;
  final AudioPlayer _player = AudioPlayer();

  String? _currentlyPlaying;

  AudioRecorderRepository(
    this._service,
    this._db,
    this._supabaseService,
    this._prefs,
  );

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
      print('✅ Memo saved locally: $filePath');

      try {
        final file = File(filePath);
        final userId = _prefs.userId; 
        final userName = _prefs.userName;

        if (userId == null) {
          print('❌ No user ID found');
          return memo;
        }
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileUrl = await _supabaseService.uploadRecording(userId, file);

        await _supabaseService.insertVoiceMemo(
          userId: userId,
          timestamp: timestamp,
          fileUrl: fileUrl, 
          userName: userName ?? 'Unknown', 
        );

        print('🚀 Uploaded to Supabase: $fileUrl');
      } catch (e) {
        print('❌ Upload failed: $e');
      }

      return memo;
    }

    print('⚠️ Recording stopped but no file returned.');
    return null;
  }

  Future<void> togglePlayback(String path, VoidCallback onPlaybackComplete) async {
    try {
      if (_currentlyPlaying == path && _player.playing) {
        await _player.stop();
        _currentlyPlaying = null;
      } else {
        _currentlyPlaying = path;
        final file = File(path);
        if (!await file.exists()) {
          print('❌ Audio file not found at path: $path');
          return;
        }
        print('🎵 Attempting to play audio from: $path');
        await _player.setFilePath(path);
        await _player.play();
        print('✅ Audio playback started');

        _player.playerStateStream.listen((state) {
          print('🎵 Player state: ${state.processingState}');
          if (state.processingState == ProcessingState.completed) {
            _currentlyPlaying = null;
            onPlaybackComplete();
          }
        });
      }
    } catch (e) {
      print('❌ Error playing audio: $e');
      _currentlyPlaying = null;
    }
  }

  Future<void> stopPlayback() async {
    try {
      await _player.stop();
      _currentlyPlaying = null;
    } catch (e) {
      print('❌ Error stopping playback: $e');
    }
  }

  String? get currentlyPlaying => _currentlyPlaying;

  void dispose() {
    _player.dispose();
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
  final supabase = SupabaseService();
  final prefs = ref.watch(sharedPreferencesServiceProvider).asData?.value;

  if (prefs == null) {
    throw Exception("SharedPreferencesService not ready");
  }

  return AudioRecorderRepository(service, db, supabase, prefs);
});

