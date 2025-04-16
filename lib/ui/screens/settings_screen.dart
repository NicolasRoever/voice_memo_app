import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shared_providers.dart';
import 'package:go_router/go_router.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(sharedPreferencesServiceProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => context.pop(),
        ),
        middle: const Text('Settings'),
      ),
      child: SafeArea(
        child: prefsAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (prefs) {
            final userName = prefs.userName ?? 'Guest';
            return ListView(
              children: [
                CupertinoListSection(
                  header: const Text('Account'),
                  children: [
                    CupertinoListTile(
                      title: const Text('User Name'),
                      additionalInfo: Text(userName),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
