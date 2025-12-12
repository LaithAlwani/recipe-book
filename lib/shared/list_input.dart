import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(T item, VoidCallback onRemove);
typedef ItemCreator<T> = Future<T?> Function(BuildContext context);

class ListInput<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final ValueChanged<List<T>> onChanged;
  final ItemWidgetBuilder<T> itemBuilder;
  final ItemCreator<T>? itemCreator; // optional for custom types

  const ListInput({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    this.itemCreator,
  });

  void _addNewItem(BuildContext context) async {
    if (T == String) {
      final controller = TextEditingController();
      final value = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Add $label'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter $label'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Add'),
            ),
          ],
        ),
      );
      if (value != null && value.isNotEmpty) {
        onChanged([...items, value as T]);
      }
    } else if (itemCreator != null) {
      final newItem = await itemCreator!(context);
      if (newItem != null) onChanged([...items, newItem]);
    } else {
      // fallback: do nothing
      print('Cannot add new item for type $T without itemCreator');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: itemBuilder(item, () {
              final newList = List<T>.from(items)..removeAt(index);
              onChanged(newList);
            }),
          );
        }).toList(),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _addNewItem(context),
          icon: const Icon(Icons.add),
          label: Text('Add $label'),
        ),
      ],
    );
  }
}
