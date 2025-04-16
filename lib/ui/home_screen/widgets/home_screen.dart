import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/home_screen/view_models/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).loadMemos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final memosAsync = ref.watch(homeViewModelProvider);
    final currentlyPlaying = ref.watch(currentlyPlayingProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Voice Memos'),
        trailing: CupertinoButton(
          onPressed: () => context.push('/settings'),
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.settings),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background_image.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Make A Gratitude Journal Entry Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: CupertinoButton.filled(
                            onPressed: () => context.push('/record'),
                            child: const Text('Record Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: memos.length,
                          itemBuilder: (context, index) {
                            final memo = memos[index];
                            final isPlaying = memo.path == currentlyPlaying;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CupertinoListTile(
                                title: Text('Recording ${memo.id}'),
                                trailing: Icon(
                                  isPlaying
                                      ? CupertinoIcons.stop_fill
                                      : CupertinoIcons.play_arrow,
                                  color: CupertinoColors.activeBlue,
                                ),
                                onTap: () async {
                                  await ref
                                      .read(homeViewModelProvider.notifier)
                                      .togglePlayback(memo.path);
                                },
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CupertinoActivityIndicator()),
                      error: (error, _) => Center(child: Text('Error: $error')),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
