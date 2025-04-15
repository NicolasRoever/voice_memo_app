import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_memo_app/ui/onboarding_screen/view_models/user_auth_view_model.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("👋 Onboarding screen shown");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Enter Name /Study ID'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoTextField(
                controller: _controller,
                placeholder: 'Your Name / Study ID',
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                  onPressed: () async {
                    final name = _controller.text.trim();
                    if (name.isNotEmpty) {
                      await ref
                          .read(userViewModelProvider.notifier)
                          .logUserSession(name);
                      // Navigate to home or next screen
                      if (mounted) {
                        context.go('/');

                      }
                    }
                  },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
