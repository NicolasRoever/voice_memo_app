import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/audio_recorder_repository.dart';
import '../../../domain/models/voice_memo.dart';

class RecorderViewModel extends StateNotifier<AsyncValue<VoiceMemo?>> {
  final AudioRecorderRepository _repo;

  RecorderViewModel(this._repo) : super(const AsyncData(null));

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  Future<void> startRecording() async {
    _isRecording = true;
    final memo = await _repo.start();
    state = AsyncData(memo);
  }

  Future<void> stopRecording() async {
    _isRecording = false;
    state = const AsyncLoading();
    final savedMemo = await _repo.stop();
    state = AsyncData(savedMemo);
  }
}

final recorderViewModelProvider =
    StateNotifierProvider<RecorderViewModel, AsyncValue<VoiceMemo?>>((ref) {
  final repo = ref.watch(audioRecorderRepositoryProvider);
  return RecorderViewModel(repo);
});
