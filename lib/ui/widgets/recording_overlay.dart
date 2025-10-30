import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../recording_screen/view_model/recording_view_model.dart';
import '../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/core/theme/app_typography.dart';

class RecordingOverlay extends ConsumerWidget {
  final Widget child;
  const RecordingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild every tick while recording (your VM should tick once per second)
    ref.watch(recorderViewModelProvider);
    final vm = ref.read(recorderViewModelProvider.notifier);
    final showing = vm.isRecording;

    return Stack(
      children: [
        child,
        // Sticky, non-dismissable bottom banner
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            offset: showing ? Offset.zero : const Offset(0, 1),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 160),
              opacity: showing ? 1 : 0,
              child: SafeArea(
                top: false,
                // the banner
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: _RecordingBanner(
                    elapsedText: vm.elapsedText,
                    onStop: vm.stopRecording,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecordingBanner extends StatelessWidget {
  final String elapsedText;
  final Future<void> Function() onStop;

  const _RecordingBanner({
    required this.elapsedText,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // full-width pill with your primary color
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: CupertinoColors.systemGrey,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // pulsing accent dot + mic
          const _PulseDot(),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.mic_fill, color: CupertinoColors.white, size: 18),
          const SizedBox(width: 10),
          // text
          Expanded(
            child: Semantics(
              liveRegion: true,
              label: 'Recording, elapsed $elapsedText',
              child: Text(
                'Recording…  $elapsedText',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Stop button in accent
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: AppColors.accent,
            onPressed: onStop,
            minSize: 36,
            borderRadius: BorderRadius.circular(12),
            child: Text(
              'Stop',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Small pulsing dot using your accent color
class _PulseDot extends StatefulWidget {
  const _PulseDot({Key? key}) : super(key: key);

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        // pulse between 0.65 and 1.0 scale + subtle fade
        final t = (math.sin((_c.value * 2 * math.pi)) + 1) / 2; // 0..1
        final scale = 0.65 + 0.35 * t;
        final opacity = 0.6 + 0.4 * t;
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
