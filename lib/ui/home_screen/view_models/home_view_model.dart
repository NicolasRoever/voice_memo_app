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

  String greeting(String? userName) {
    final name = (userName?.isNotEmpty == true) ? userName! : 'Guest';
    // Match any numeric character or '@'
    if (RegExp(r'[\d@\-]').hasMatch(name)) {
      return 'Hi, You 👋';
    }
    return 'Hi, $name 👋';
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
  final current = _ref.read(currentlyPlayingProvider);

  if (current == path) {
    // 🔁 Stop current
    await _repository.stopPlayback();
    _ref.read(currentlyPlayingProvider.notifier).state = null;
    return;
  }

  // 🛑 Stop any other playback first
  if (current != null) {
    await _repository.stopPlayback();
  }

  // ✅ Update state BEFORE playing to reflect changes in UI immediately
  _ref.read(currentlyPlayingProvider.notifier).state = path;

  await _repository.togglePlayback(path, () {
    // Reset after completion
    _ref.read(currentlyPlayingProvider.notifier).state = null;
  });
}

}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<List<VoiceMemo>>>((ref) {
  final repo = ref.watch(audioRecorderRepositoryProvider);
  return HomeViewModel(repo, ref);
});
