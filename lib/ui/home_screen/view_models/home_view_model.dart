import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/audio_recorder_repository.dart';
import '../../../domain/models/voice_memo.dart';

final currentlyPlayingProvider = StateProvider<String?>((ref) => null);


class HomeViewModel extends StateNotifier<AsyncValue<List<VoiceMemo>>> {
  final AudioRecorderRepository _repository;
  final Ref _ref;

  HomeViewModel(this._repository, this._ref) : super(const AsyncData([])) {
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
    await _repository.togglePlayback(path, () {
      _ref.read(currentlyPlayingProvider.notifier).state = null;
    });


    final current = _repository.currentlyPlaying;
    _ref.read(currentlyPlayingProvider.notifier).state = current;
  }

}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<List<VoiceMemo>>>((ref) {
  final repo = ref.watch(audioRecorderRepositoryProvider);
  return HomeViewModel(repo, ref);
});
