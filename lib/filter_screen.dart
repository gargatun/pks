import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final bool currentOrganicOnly;
  final String currentCategory;
  final Function(bool, String) onApplyFilter;

  FilterScreen({
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
        title: Text("Фильтр продуктов"),
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
                Text("Только органические продукты"),
              ],
            ),
            SizedBox(height: 20),
            Text("Категория:"),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onApplyFilter(organicOnly, selectedCategory);
                Navigator.pop(context);
              },
              child: Text("Применить фильтр"),
            ),
          ],
        ),
      ),
    );
  }
}
