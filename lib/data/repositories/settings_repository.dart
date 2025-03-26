import '../services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/onboarding_screen/view_models/user_auth_view_model.dart';

class SettingsRepository {
  final SharedPreferencesService _prefs;

  SettingsRepository(this._prefs);

  String? get userName => _prefs.userName;

  Future<void> updateUserName(String newName) async {
    await _prefs.saveUserName(newName);
  }
}


final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SettingsRepository(prefs);
});