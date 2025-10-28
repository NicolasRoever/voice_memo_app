import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:joymemos/ui/onboarding_screen/view_models/user_auth_view_model.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_colors.dart';
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
                      'Welcome 😊! ',
                      style: AppTypography.heading,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Enter your Trial Participant Code Here: ',
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
                            placeholder: 'enter 8 digit code',
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          ),
                          const SizedBox(height: 24),
                          CupertinoButton(
                            color: AppColors.primary,
                            onPressed: () async {
                              final name = _controller.text.trim();
                              if (name.isNotEmpty) {
                                await ref.read(userViewModelProvider.notifier).logUserSession(name);
                                if (mounted) context.go('/');
                              }
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            child: Text(
                              'Start Being Grateful',
                              style: AppTypography.buttonText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Info Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: CupertinoColors.systemGrey4, width: 1),
                      ),
                      child: Text(
                        'Based on your input, you’ll receive personalized, AI-generated tips for habits that can improve your mood, sent via email.',
                        style: AppTypography.subtitle.copyWith(
                          color: CupertinoColors.black.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
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
