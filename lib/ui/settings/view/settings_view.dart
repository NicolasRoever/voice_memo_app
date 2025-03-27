import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/settings_view_model.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(settingsViewModelProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Settings'),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => context.go('/'),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Current Name: ${name ?? "Not set"}'),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _controller,
                placeholder: 'New name or ID',
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                child: const Text('Update'),
                onPressed: () async {
                  final newName = _controller.text.trim();
                  if (newName.isNotEmpty) {
                    await ref
                        .read(settingsViewModelProvider.notifier)
                        .updateUserName(newName);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
