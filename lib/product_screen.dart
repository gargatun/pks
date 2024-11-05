import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product, required this.addToCart});

  final Map<String, dynamic> product;
  final VoidCallback addToCart;

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
            Image.asset(product["image"], height: 200),
            const SizedBox(height: 10),
            Text(
              product["name"],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "${product["price"]} руб.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              "Это подробное описание продукта.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addToCart,
              child: const Text("Добавить в корзину"),
            ),
          ],
        ),
      ),
    );
  }
}
