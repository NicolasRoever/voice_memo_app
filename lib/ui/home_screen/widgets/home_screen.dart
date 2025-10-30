import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../ui/core/theme/app_colors.dart';
import '../../../ui/core/theme/app_typography.dart';
import '../../../providers/shared_providers.dart';
import '../view_models/home_view_model.dart';

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
        /// Background image
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

        /// Page content
        CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top bar
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  child: Row(
                    children: [
                      const Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => context.push('/settings'),
                        child: const Icon(
                          CupertinoIcons.settings,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Greeting
                prefsAsync.when(
                  data: (prefs) {
                    final userName = prefs.userName;
                    final viewModel = ref.watch(homeViewModelProvider.notifier);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Text(
                        viewModel.greeting(userName),
                        style: AppTypography.mainHeading.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: CupertinoActivityIndicator(),
                  ),
                  error: (err, _) => const SizedBox.shrink(),
                ),

                /// Record prompt
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background_cards,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Make a JoyMemo', style: AppTypography.heading),
                        const SizedBox(height: 12),
                        Center(
                          child: CupertinoButton(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
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

                /// JoyMemo list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                          decoration: BoxDecoration(
                            color: AppColors.background_cards,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Your JoyMemo History',
                                  style: AppTypography.heading.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isPlaying
                                              ? AppColors.accent.withOpacity(0.15)
                                              : CupertinoColors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isPlaying
                                                ? AppColors.accent
                                                : CupertinoColors.systemGrey4.withOpacity(0.5),
                                            width: 1.2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: CupertinoColors.systemGrey.withOpacity(0.1),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'JoyMemo ${memo.id}',
                                                  style: AppTypography.heading.copyWith(
                                                    fontSize: 16,
                                                    color: isPlaying
                                                        ? AppColors.primary
                                                        : AppColors.primary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  DateFormat.yMMMMd()
                                                      .add_Hm()
                                                      .format(memo.createdAt.toLocal()),
                                                  style: AppTypography.subtitle.copyWith(
                                                    color: CupertinoColors.systemGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              isPlaying
                                                  ? CupertinoIcons.stop_fill
                                                  : CupertinoIcons.play_arrow_solid,
                                              color: isPlaying
                                                  ? AppColors.accent
                                                  : AppColors.primary,
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
                      loading: () =>
                          const Center(child: CupertinoActivityIndicator()),
                      error: (error, _) =>
                          Center(child: Text('Error: $error')),
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
