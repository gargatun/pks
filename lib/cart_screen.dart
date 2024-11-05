import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  CartScreen({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Корзина"),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            child: ListTile(
              leading: Image.asset(item["image"]),
              title: Text(item["name"]),
              subtitle: Text("${item["price"]} руб."),
            ),
          );
        },
      ),
    );
  }
}
