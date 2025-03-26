import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/settings_repository.dart';

class SettingsViewModel extends StateNotifier<String?> {
  final SettingsRepository _repo;

  SettingsViewModel(this._repo) : super(_repo.userName);

  Future<void> updateUserName(String newName) async {
    await _repo.updateUserName(newName);
    state = newName;
  }
}

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, String?>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SettingsViewModel(repo);
});
