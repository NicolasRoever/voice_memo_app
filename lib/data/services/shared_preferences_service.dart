import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  
  static const _userNameKey = 'user_name';

  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  String? get userName => _prefs.getString(_userNameKey);

  Future<void> saveUserName(String name) async {
    await _prefs.setString(_userNameKey, name);
  }

  Future<void> clearUserName() async {
    await _prefs.remove(_userNameKey);
  }

  bool get isUserRegistered => _prefs.containsKey(_userNameKey);
}
