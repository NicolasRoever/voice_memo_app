import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../ui/home_screen/widgets/home_screen.dart';
import '../ui/recording_screen/view/recording_screen_view.dart';
import '../ui/onboarding_screen/widgets/user_auth_view.dart';
import '../providers/shared_providers.dart';
import '../ui/settings_screen/settings_screen.dart';
import '../ui/widgets/recording_overlay.dart';

final appRouterProvider = Provider<GoRouter>((ref) {

  final prefsAsync = ref.watch(sharedPreferencesServiceProvider);

  return prefsAsync.when(
    loading: () => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
    error: (error, stack) => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
    data: (prefs) {
    final String? name = prefs.userName;

    return GoRouter(
      initialLocation: name == null || name.isEmpty ? '/onboarding' : '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/record',
          builder: (context, state) => const RecorderScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
  );
});
