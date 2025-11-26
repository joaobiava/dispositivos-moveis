import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.color = Colors.white,
  });

  final String label;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: DropdownButtonFormField<String>(
          value: value,

          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade600),

            floatingLabelStyle: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.bold,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),

          icon: Icon(
            Icons.arrow_drop_down_rounded,
            size: 32,
            color: Colors.orange.shade700,
          ),

          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 16)),
                ),
              )
              .toList(),

          onChanged: onChanged,

          validator: (value) =>
              value == null || value.isEmpty ? "Selecione uma opção" : null,
        ),
      ),
    );
  }
}
