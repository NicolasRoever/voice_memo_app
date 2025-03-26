import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_memo_app/data/services/shared_preferences_service.dart';

void main() {
  late SharedPreferencesService prefsService;

  setUp(() async {
    // Set up mock initial values (empty in this case)
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    prefsService = SharedPreferencesService(prefs);
  });

  test('Initial user is not registered', () {
    expect(prefsService.isUserRegistered, false);
    expect(prefsService.userName, isNull);
  });

  test('Saves and reads user name', () async {
    await prefsService.saveUserName('JohnDoe');

    expect(prefsService.userName, 'JohnDoe');
    expect(prefsService.isUserRegistered, true);
  });

  test('Clears user name', () async {
    await prefsService.saveUserName('JohnDoe');
    await prefsService.clearUserName();

    expect(prefsService.userName, isNull);
    expect(prefsService.isUserRegistered, false);
  });
}
