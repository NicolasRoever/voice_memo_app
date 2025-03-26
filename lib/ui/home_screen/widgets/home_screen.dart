import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/home_screen/view_models/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosAsync = ref.watch(homeViewModelProvider);

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
                data: (memos) => memos.isEmpty
                    ? const Center(child: Text('No recordings yet.'))
                    : ListView.builder(
                        itemCount: memos.length,
                        itemBuilder: (context, index) {
                          final memo = memos[index];
                          return ListTile(
                            title: Text('Recording ${memo.id}'),
                            trailing: const Icon(CupertinoIcons.play_arrow),
                            onTap: () {
                              // TODO: Playback feature
                            },
                          );
                        },
                      ),
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
