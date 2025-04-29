import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entry.dart';

final entriesProvider = StateNotifierProvider<EntriesNotifier, List<Entry>>((ref) {
  return EntriesNotifier();
});

class EntriesNotifier extends StateNotifier<List<Entry>> {
  EntriesNotifier() : super([]);

  void addEntry(String text) {
    state = [...state, Entry(text)];
  }

  void removeEntry(Entry entry) {
    state = state.where((e) => e != entry).toList();
  }

  void clearEntries() {
    state = [];
  }
}
