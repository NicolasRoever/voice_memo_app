import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider = FutureProvider<SharedPreferencesService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SharedPreferencesService(prefs);
});

final isUserRegisteredProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesServiceProvider).maybeWhen(
    data: (service) => service,
    orElse: () => null,
  );

  if (prefs == null) return false;
  return prefs.isUserRegistered;
});
