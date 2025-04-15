import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routing/router.dart';
import 'data/services/shared_preferences_service.dart';
import 'ui/onboarding_screen/view_models/user_auth_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file. Ensure the file is at the project root.
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final sharedPrefsService = SharedPreferencesService(prefs);

   // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefsService),
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
