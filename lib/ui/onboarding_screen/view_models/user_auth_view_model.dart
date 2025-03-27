import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_memo_app/data/services/shared_preferences_service.dart';

class UserAuthViewModel extends StateNotifier<bool> {
  final SharedPreferencesService _prefs;

  UserAuthViewModel(this._prefs) : super(_prefs.isUserRegistered);

  Future<void> register(String name) async {
    await _prefs.saveUserName(name);
    state = true; // triggers rebuilds/listeners
  }
}

final userAuthProvider = StateNotifierProvider<UserAuthViewModel, bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return UserAuthViewModel(prefs);
});

final sharedPrefsProvider = Provider<SharedPreferencesService>((ref) {
  throw UnimplementedError(); // will override this in main.dart
});
