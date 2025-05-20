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

            // 🔹 Scrollable ListView of entries
            Expanded(
              child:ListView.separated(
                itemCount: entries.length,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  color: Colors.grey,
                  indent: 8,
                  endIndent: 8,
                ),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Row(
                    children: [
                      // 🔵 Renkli daire
                      Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: getColorFromText(entry.text),
                          shape: BoxShape.circle,
                        ),
                      ),

                      // 📝 Entry metni (genişleyerek ortada kalacak)
                      Expanded(
                        child: Text(
                          entry.text,
                          style: const TextStyle(fontSize: 16),
                          // overflow: TextOverflow.ellipsis, // eğer uzun metin kırpılmak istenirse aktifleştirilebilir
                        ),
                      ),

                      // ✏️ Düzenleme butonu
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                        onPressed: () {
                          _showEditEntryDialog(context, entry);
                        },
                      ),

                      // 🗑️ Silme butonu
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.blueGrey),
                        onPressed: () {
                          ref.read(entriesProvider.notifier).removeEntry(entry);
                        },
                      ),
                    ],
                  );
                },
              ),
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
    // Renk üretici yardımcı fonksiyon
  Color getColorFromText(String text) {
    return Color((text.hashCode * 0xFFFFFF) | 0xFF000000);
  }
  void _showEditEntryDialog(BuildContext context, entry) {
    final editController = TextEditingController(text: entry.text);
    final editFocusNode = FocusNode();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(Duration.zero, () {
              FocusScope.of(context).requestFocus(editFocusNode);
            });

            return AlertDialog(
              title: const Text('Edit Entry'),
              content: TextField(
                controller: editController,
                focusNode: editFocusNode,
                decoration: const InputDecoration(hintText: 'Edit entry'),
                autofocus: true,
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
                    if (editController.text.isNotEmpty) {
                      ref.read(entriesProvider.notifier).editEntry(entry, editController.text);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}