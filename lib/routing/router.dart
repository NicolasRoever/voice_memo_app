import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../ui/home_screen/widgets/home_screen.dart';
import '../ui/onboarding_screen/widgets/user_auth_view.dart';
import '../ui/onboarding_screen/view_models/user_auth_view_model.dart';
import '../ui/recording_screen/view/recording_screen_view.dart';



class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final isRegistered = ref.watch(userAuthProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(userAuthProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final loggingIn = state.uri.path == '/onboarding';

      if (!isRegistered && !loggingIn) {
        return '/onboarding';
      } else if (isRegistered && loggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/record',
        builder: (context, state) => const RecorderScreen(),
      ),
    ],
  );
});
