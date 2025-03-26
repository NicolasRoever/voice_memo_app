import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/voice_memo_repository.dart';
import '../../../domain/models/voice_memo.dart';

class HomeViewModel extends StateNotifier<List<VoiceMemo>> {
  final VoiceMemoRepository _repository;

  HomeViewModel(this._repository) : super([]) {
    loadMemos();
  }

  Future<void> loadMemos() async {
    final memos = await _repository.fetchAllVoiceMemos();
    state = memos;
  }
}

// Inlined provider
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, List<VoiceMemo>>(
  (ref) => HomeViewModel(VoiceMemoRepository()),
);
