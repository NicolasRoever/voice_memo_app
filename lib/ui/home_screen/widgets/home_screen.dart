import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/home_screen/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import '../../../ui/core/theme/app_colors.dart';
import '../../../providers/shared_providers.dart';
import '../../../ui/core/theme/app_typography.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).loadMemos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final memosAsync = ref.watch(homeViewModelProvider);
    final currentlyPlaying = ref.watch(currentlyPlayingProvider);
    final prefsAsync = ref.watch(sharedPreferencesServiceProvider);

    return Stack(
      children: [
        // Background image
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

        // Page content
        CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom App Bar (no blur)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Row(
                    children: [
                      const Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.push('/settings'),
                        child: const Icon(CupertinoIcons.settings, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

                // Greeting
                prefsAsync.when(
                  data: (prefs) {
                    final userName = prefs.userName;
                    final viewModel = ref.watch(homeViewModelProvider.notifier);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        viewModel.greeting(userName),
                        style: AppTypography.mainHeading,
                      ),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: CupertinoActivityIndicator(),
                  ),
                  error: (err, _) => const SizedBox.shrink(),
                ),

                // Record Prompt
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background_cards,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Make A JoyMemo',
                          style: AppTypography.heading,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: CupertinoButton(
                            color: AppColors.primary,
                            onPressed: () async {
                              await context.push('/record');
                              ref.read(homeViewModelProvider.notifier).loadMemos();
                            },
                            child: Text('Record Now', style: AppTypography.buttonText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Gratitude History List
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: memosAsync.when(
                      data: (memos) {
                        if (memos.isEmpty) {
                          return const Center(
                            child: Text(
                              'No JoyMemos yet. 😢',
                              style: AppTypography.subtitle,
                            ),
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background_cards,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: CupertinoColors.systemGrey4.withOpacity(0.5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.systemGrey.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                  'Your JoyMemo History',
                                  style: AppTypography.heading,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  itemCount: memos.length,
                                  itemBuilder: (context, index) {
                                    final memo = memos[index];
                                    final isPlaying = memo.path == currentlyPlaying;

                                    return GestureDetector(
                                      onTap: () async {
                                        await ref
                                            .read(homeViewModelProvider.notifier)
                                            .togglePlayback(memo.path);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: isPlaying
                                              ? CupertinoColors.systemGrey4.withOpacity(0.3)
                                              : CupertinoColors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isPlaying
                                                ? Theme.of(context).colorScheme.primary
                                                : CupertinoColors.systemGrey5,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'JoyMemo ${memo.id}',
                                                  style: AppTypography.heading.copyWith(
                                                    fontSize: 16,
                                                    color: isPlaying
                                                        ? Theme.of(context).colorScheme.primary
                                                        : CupertinoColors.label,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${DateFormat.yMMMMd().format(memo.createdAt.toLocal())} '
                                                  '${memo.createdAt.toLocal().hour}:${memo.createdAt.toLocal().minute.toString().padLeft(2, '0')}',
                                                  style: AppTypography.subtitle,
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              isPlaying
                                                  ? CupertinoIcons.stop_fill
                                                  : CupertinoIcons.play_arrow,
                                              color: isPlaying
                                                  ? AppColors.accent
                                                  : Theme.of(context).colorScheme.primary,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(child: CupertinoActivityIndicator()),
                      error: (error, _) => Center(child: Text('Error: $error')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
