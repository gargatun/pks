import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback addToCart;

  ProductScreen({required this.product, required this.addToCart});

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
            SizedBox(height: 10),
            Text(
              product["name"],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              "${product["price"]} руб.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),
            Text(
              "Это подробное описание продукта.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addToCart();
                Navigator.pop(context); // Вернуться на главный экран
              },
              child: Text("Добавить в корзину"),
            ),
          ],
        ),
      ),
    );
  }
}
