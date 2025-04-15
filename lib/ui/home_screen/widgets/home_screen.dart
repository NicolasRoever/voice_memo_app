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
          padding: EdgeInsets.zero,
          onPressed: () => context.go('/settings'),
          child: const Icon(CupertinoIcons.settings),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton.filled(
                onPressed: () => context.go('/record'),
                child: const Text('Record Now'),
              ),
            ),
            Expanded(
              child: memosAsync.when(
                data: (memos) {
                  if (memos.isEmpty) {
                    return const Center(child: Text('No recordings yet.'));
                  }

                  return ListView.builder(
                    itemCount: memos.length,
                    itemBuilder: (context, index) {
                      final memo = memos[index];
                      final isPlaying = memo.path == currentlyPlaying;

                      return CupertinoListTile(
                        title: Text('Recording ${memo.id}'),
                        trailing: Icon(
                          isPlaying ? CupertinoIcons.stop_fill : CupertinoIcons.play_arrow,
                        ),
                        onTap: () async {
                          print('🎧 Tapped memo: ${memo.path}');
                          await ref
                              .read(homeViewModelProvider.notifier)
                              .togglePlayback(memo.path);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
