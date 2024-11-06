// lib/screens/product_screen.dart

import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback addToCart;

  const ProductScreen({super.key, required this.product, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(product["image"], height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              product["name"],
              style: Theme.of(context).textTheme.headlineMedium, // Обновлённый стиль
            ),
            const SizedBox(height: 10),
            Text(
              "${product["price"]} руб.",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green), // Обновлённый стиль
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: addToCart,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text("Добавить в корзину"),
            ),
          ],
        ),
      ),
    );
  }
}
