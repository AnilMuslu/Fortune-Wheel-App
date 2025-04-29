import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/wheel_provider.dart';

class EntryList extends ConsumerWidget {
  const EntryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider);
    
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: entries.length,
          separatorBuilder: (context, index) => const Divider(
            thickness: 0.5,
            color: Colors.black26,
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return ListTile(
              leading: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  ref.read(entriesProvider.notifier).removeEntry(entry);
                },
              ),
              title: Text(entry.text),
            );
          },
        ),    
      ),
    );
  }
}