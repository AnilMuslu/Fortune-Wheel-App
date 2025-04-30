import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/wheel_provider.dart';

class EntryList extends ConsumerStatefulWidget {
  const EntryList({super.key});

  @override
  ConsumerState<EntryList> createState() => _EntryListState();
}

class _EntryListState extends ConsumerState<EntryList> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(entriesProvider);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔹 Header + Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Entries",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: (){
                    _controller.clear(); // Temizlemeden önceki veri kalmasın
                    _showAddEntryDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🔹 ListView of entries
            ListView.separated(
              shrinkWrap: true,
              itemCount: entries.length,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(
                thickness: 1,
                color: Colors.grey,
                indent: 8,
                endIndent: 8,
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
          ],
        ),
      ),
    );
  }
  
  void _showAddEntryDialog(BuildContext context) {
    _controller.clear();

    showDialog(
      context: context,
      builder: (context) {
        // Bu sayede setState kullanılabilir ve Focus sonrası çalışır
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(Duration.zero, () {
              FocusScope.of(context).requestFocus(_focusNode);
            });

              return AlertDialog(
              title: const Text('Add Entry'),
              content: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(hintText: 'Entry name'),
                autofocus: true, // Bu da yardımcı olur
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      ref.read(entriesProvider.notifier).addEntry(_controller.text);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  } 
}