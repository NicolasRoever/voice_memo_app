import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../view_model/recording_view_model.dart';

class RecorderScreen extends ConsumerWidget {
  const RecorderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recorderViewModelProvider);
    final viewModel = ref.read(recorderViewModelProvider.notifier);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Voice Recorder'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.home),
          onPressed: () => context.go('/'),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            recordingState.when(
              data: (memo) => Column(
                children: [
                  Icon(
                    viewModel.isRecording
                        ? CupertinoIcons.mic_circle_fill
                        : CupertinoIcons.mic_slash_fill,
                    size: 80,
                    color: viewModel.isRecording
                        ? CupertinoColors.systemRed
                        : CupertinoColors.systemGrey,
                  ),
                  const SizedBox(height: 20),
                  Text(viewModel.isRecording
                      ? 'Recording...'
                      : memo != null
                          ? 'Saved: ${memo.path.split('/').last}'
                          : 'Ready to record'),
                ],
              ),
              loading: () => const CupertinoActivityIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 40),
            CupertinoButton.filled(
              onPressed: () async {
                if (viewModel.isRecording) {
                  await viewModel.stopRecording();
                } else {
                  await viewModel.startRecording();
                }
              },
              child: Text(viewModel.isRecording ? 'Stop' : 'Record'),
            ),
          ],
        ),
      ),
    );
  }
}
