import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/core/theme/app_colors.dart';
import '../view_model/recording_view_model.dart';
import '../../../ui/core/theme/app_typography.dart';

class RecorderScreen extends ConsumerWidget {
  const RecorderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recorderViewModelProvider);
    final viewModel = ref.read(recorderViewModelProvider.notifier);

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

        // Main Content + NavBar
        CupertinoPageScaffold(
          backgroundColor: CupertinoColors.transparent,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.transparent,
            border: null,
            leading: CupertinoButton(
              padding: const EdgeInsets.only(left: 8),
              onPressed: () => context.pop(),
              child: const Icon(CupertinoIcons.home, color: AppColors.primary),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Prompt Card
                     Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.background_cards,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'What are three things you are grateful for today?',
                          style: AppTypography.heading,
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Recording Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                      decoration: BoxDecoration(
                        color:  AppColors.background_cards,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          recordingState.when(
                            data: (memo) => Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    viewModel.isRecording
                                        ? CupertinoIcons.mic_circle_fill
                                        : CupertinoIcons.mic_slash_fill,
                                    size: 80,
                                    color: viewModel.isRecording
                                        ? AppColors.accent
                                        : AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  viewModel.isRecording
                                      ? 'Recording now...'
                                      : memo != null
                                          ? 'Recording saved!'
                                          : 'Ready to record',
                                  style: AppTypography.subtitle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            loading: () => const CupertinoActivityIndicator(),
                            error: (e, _) => Text('Error: $e'),
                          ),
                          const SizedBox(height: 32),
                          CupertinoButton(
                            color: AppColors.primary,
                            onPressed: () async {
                              if (viewModel.isRecording) {
                                await viewModel.stopRecording();
                              } else {
                                await viewModel.startRecording();
                              }
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            child: Text(
                              viewModel.isRecording ? 'Stop' : 'Record Now',
                              style: AppTypography.buttonText,
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
