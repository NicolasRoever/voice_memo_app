import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joymemos/ui/onboarding_screen/view_models/user_auth_view_model.dart';
import '../../core/theme/app_typography.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Image.asset(
                'assets/images/background_image.png',
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              );
            },
          ),
        ),

        CupertinoPageScaffold(
          backgroundColor: CupertinoColors.transparent,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.transparent,
            border: null,
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Heading
                    Text(
                      'What\'s your name?',
                      style: AppTypography.heading,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'We want to know how to call you 😊',
                      style: AppTypography.subtitle,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Input + Button Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey.withOpacity(0.01),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CupertinoTextField(
                            controller: _controller,
                            placeholder: 'Your Name',
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          ),
                          const SizedBox(height: 24),
                          CupertinoButton.filled(
                            onPressed: () async {
                              final name = _controller.text.trim();
                              if (name.isNotEmpty) {
                                await ref.read(userViewModelProvider.notifier).logUserSession(name);
                                if (mounted) context.go('/');
                              }
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            child: const Text(
                              'Start Being Grateful',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
