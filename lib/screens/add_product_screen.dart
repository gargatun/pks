// lib/screens/add_product_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  double price = 0.0;
  String image = '';
  bool organic = false;
  String category = 'Фрукты';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить продукт'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название продукта';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Цена'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену продукта';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректное число';
                  }
                  return null;
                },
                onSaved: (value) {
                  price = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Изображение (URL или путь)'),
                onSaved: (value) {
                  image = value ?? '';
                },
              ),
              SwitchListTile(
                title: const Text('Органический'),
                value: organic,
                onChanged: (value) {
                  setState(() {
                    organic = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Категория'),
                value: category,
                items: ['Фрукты', 'Овощи'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Добавить продукт'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    print('Попытка добавить новый продукт');

                    Product newProduct = Product(
                      name: name,
                      price: price,
                      image: image,
                      organic: organic,
                      category: category,
                    );

                    try {
                      Product addedProduct = await ApiService.addNewProduct(newProduct);

                      print('Продукт успешно добавлен: ${addedProduct.toJson()}');

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Продукт добавлен')),
                      );
                      Navigator.pop(context, true); // Возвращаем true при успешном добавлении
                    } catch (e) {
                      print('Ошибка при добавлении продукта: $e');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка при добавлении продукта: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
