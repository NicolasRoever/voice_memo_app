import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/shared_providers.dart';
import '../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        CupertinoPageScaffold(
          backgroundColor: CupertinoColors.transparent,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoColors.transparent,
            border: null,
            leading: CupertinoNavigationBarBackButton(
              onPressed: () => context.pop(),
              color: AppColors.primary,
            ),
            middle: const Text('Settings', style: TextStyle(color: CupertinoColors.white)),
          ),
          child: SafeArea(
            child: prefsAsync.when(
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (prefs) {
                final userName = prefs.userName ?? 'Guest';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CupertinoListSection.insetGrouped(
                        backgroundColor: AppColors.background_cards,
                        header: const Text('Account'),
                        children: [
                          CupertinoListTile(
                            title: const Text('User Name'),
                            additionalInfo: Text(userName),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: AppColors.background_cards,
                        header: const Text('App Info'),
                        children: const [
                          CupertinoListTile(
                            title: Text('Developer'),
                            additionalInfo: Text('Nicolas Roever'),
                          ),
                          CupertinoListTile(
                            title: Text('Contact'),
                            subtitle: Text(
                              'nicolas.roever@wiso.uni-koeln.de',
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Made with ❤️ in Cologne',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
