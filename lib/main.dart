import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routing/router.dart';
import 'data/services/shared_preferences_service.dart';
import 'ui/onboarding_screen/view_models/user_auth_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(SharedPreferencesService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return CupertinoApp.router(
      routerConfig: router,
      title: 'Voice Memo',
      theme: const CupertinoThemeData(
        primaryColor: Color.fromARGB(255, 0, 55, 113),
      ),
    );
  }
}
