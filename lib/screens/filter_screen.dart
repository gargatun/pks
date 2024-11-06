// lib/screens/filter_screen.dart

import 'package:flutter/material.dart';
import '../typedefs.dart'; // Импортируем typedef

class FilterScreen extends StatefulWidget {
  final bool currentOrganicOnly;
  final String currentCategory;
  final ApplyFilterCallback onApplyFilter; // Используем typedef

  const FilterScreen({
    super.key,
    required this.currentOrganicOnly,
    required this.currentCategory,
    required this.onApplyFilter,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late bool organicOnly;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    organicOnly = widget.currentOrganicOnly;
    selectedCategory = widget.currentCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Фильтр продуктов"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Выберите параметры фильтрации:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Row(
              children: [
                Checkbox(
                  value: organicOnly,
                  onChanged: (value) {
                    setState(() {
                      organicOnly = value!;
                    });
                  },
                ),
                const Text("Только органические продукты"),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Категория:"),
            ListTile(
              title: const Text('Фрукты'),
              leading: Radio<String>(
                value: "Фрукты",
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Овощи'),
              leading: Radio<String>(
                value: "Овощи",
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onApplyFilter(organicOnly, selectedCategory);
                Navigator.pop(context);
              },
              child: const Text("Применить фильтр"),
            ),
          ],
        ),
      ),
    );
  }
}
