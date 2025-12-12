import 'package:flutter/material.dart';

class ChipsInput extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  final List<String>? suggestions;

  const ChipsInput({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.suggestions,
  });

  void _addChip(BuildContext context) {
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
              if (value.isNotEmpty) onChanged([...items, value]);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Chip(
              label: Text(item),
              onDeleted: () {
                onChanged(items.where((e) => e != item).toList());
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _addChip(context),
          icon: const Icon(Icons.add),
          label: Text('Add $label'),
        ),
      ],
    );
  }
}
