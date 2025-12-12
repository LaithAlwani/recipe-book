import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(T item, VoidCallback onRemove);

class ListInput<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final ValueChanged<List<T>> onChanged;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListInput({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
  });

  void _addNewItem(BuildContext context) {
    // Simple text input for strings; for custom objects, pass via itemBuilder or handle outside
    if (T == String) {
      final controller = TextEditingController();
      showDialog(
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
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  onChanged([...items, value as T]);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
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
