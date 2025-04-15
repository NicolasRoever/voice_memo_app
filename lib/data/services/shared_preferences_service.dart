import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharedPreferencesService {
  static const _userNameKey = 'user_name';
  static const _userIdKey = 'user_id';

  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  String? get userName => _prefs.getString(_userNameKey);
  String? get userId => _prefs.getString(_userIdKey);

  Future<void> saveUserCredentials(String id, String name) async {
    await _prefs.setString(_userIdKey, id);
    await _prefs.setString(_userNameKey, name);
  }

  bool get isUserRegistered =>
      _prefs.containsKey(_userNameKey) && _prefs.containsKey(_userIdKey);
}

final sharedPreferencesProvider = Provider<SharedPreferencesService>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
