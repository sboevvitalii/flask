import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final vibrationProvider = StateProvider<bool>((ref) => true);
final soundProvider = StateProvider<bool>((ref) => true);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibrationEnabled = ref.watch(vibrationProvider);
    final soundEnabled = ref.watch(soundProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.vibration),
              title: const Text('Вибрация'),
              subtitle: const Text('Включить виброотклик'),
              value: vibrationEnabled,
              onChanged: (value) {
                ref.read(vibrationProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.volume_up),
              title: const Text('Звук'),
              subtitle: const Text('Включить звуковые эффекты'),
              value: soundEnabled,
              onChanged: (value) {
                ref.read(soundProvider.notifier).state = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
