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
      Positioned.fill(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Image.asset(
              'assets/images/background_image.jpg',
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
          leading: CupertinoButton(
            padding: const EdgeInsets.only(left: 8),
            onPressed: () => context.push('/settings'),
            child: const Icon(CupertinoIcons.settings),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              prefsAsync.when(
                data: (prefs) {
                  final userName = prefs.userName ?? 'Guest';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      'Hi, $userName 👋',
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

              // 📝 Record prompt card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.background_cards,
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
                        'Make A Gratitude Journal Entry', 
                        style: AppTypography.heading,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: CupertinoButton.filled(
                          onPressed: () async {
                            await context.push('/record');
                            ref.read(homeViewModelProvider.notifier).loadMemos();
                          },
                          child: const Text('Record Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 🧾 Gratitude entries section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: memosAsync.when(
                    data: (memos) {
                      if (memos.isEmpty) {
                        return const Center(
                          child: Text(
                            'No recordings yet.',
                            style: TextStyle(fontSize: 16),
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
                                'Your Gratitude History',
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

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CupertinoListTile(
                                      title: Text('Gratitude Entry ${memo.id}'),
                                      subtitle: Text('${DateFormat.yMMMMd().format(memo.createdAt.toLocal())} ${memo.createdAt.toLocal().hour}:${memo.createdAt.toLocal().minute}'),
                                      trailing: Icon(
                                        isPlaying
                                            ? CupertinoIcons.stop_fill
                                            : CupertinoIcons.play_arrow,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onTap: () async {
                                        await ref
                                            .read(homeViewModelProvider.notifier)
                                            .togglePlayback(memo.path);
                                      },
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
