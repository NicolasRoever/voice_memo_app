import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/audio_recorder_repository.dart';
import '../../../domain/models/voice_memo.dart';

class HomeViewModel extends StateNotifier<AsyncValue<List<VoiceMemo>>> {
  final AudioRecorderRepository _repository;

  HomeViewModel(this._repository) : super(const AsyncData([])) {
    loadMemos(); // Load on init
  }

  Future<void> loadMemos() async {
    state = const AsyncLoading();
    try {
      final memos = await _repository.fetchAll();
      print('📥 Loaded ${memos.length} memos from DB');
      state = AsyncData(memos);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> togglePlayback(String path) async {
    await _repository.togglePlayback(path);
  }

  String? get currentlyPlaying => _repository.currentlyPlaying;
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<List<VoiceMemo>>>((ref) {
  final repo = ref.watch(audioRecorderRepositoryProvider);
  return HomeViewModel(repo);
});
