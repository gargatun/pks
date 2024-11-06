// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Корзина"),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text("Ваша корзина пуста."),
            );
          }
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(item["image"]),
                  title: Text(item["name"]),
                  subtitle: Text("${item["price"]} руб."),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      cart.removeItem(item);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
