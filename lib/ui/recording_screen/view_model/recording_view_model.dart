import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/audio_recorder_repository.dart';
import '../../../domain/models/voice_memo.dart';

class RecorderViewModel extends StateNotifier<AsyncValue<VoiceMemo?>> {
  final AudioRecorderRepository _repo;
  Timer? _ticker;
  DateTime? _startedAt;

  RecorderViewModel(this._repo) : super(const AsyncData(null));

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  // --- NEW: elapsed time in Duration + formatted text ---
  Duration get elapsed {
    if (!_isRecording || _startedAt == null) return Duration.zero;
    return DateTime.now().difference(_startedAt!);
  }

  String get elapsedText {
    final d = elapsed;
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
  // ------------------------------------------------------

  Future<void> startRecording() async {
    _isRecording = true;
    _startedAt = DateTime.now();
    _startTicker(); // NEW
    final memo = await _repo.start();
    state = AsyncData(memo);
  }

  Future<void> stopRecording() async {
    _isRecording = false;
    _stopTicker(); // NEW
    state = const AsyncLoading();
    final savedMemo = await _repo.stop();
    state = AsyncData(savedMemo);
  }

  // --- NEW: lightweight ticker to refresh UI once per second ---
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isRecording) {
        state = state; // force Riverpod rebuild (for overlay timer)
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}

final recorderViewModelProvider =
    StateNotifierProvider<RecorderViewModel, AsyncValue<VoiceMemo?>>((ref) {
  final repo = ref.watch(audioRecorderRepositoryProvider);
  return RecorderViewModel(repo);
});
