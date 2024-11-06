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
              return Dismissible(
                key: Key(item.product["name"]),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Удалить товар"),
                      content: const Text("Вы уверены, что хотите удалить этот товар из корзины?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Отмена"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Удалить"),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  cart.removeItem(item.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.product["name"]} удален(а) из корзины')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: ListTile(
                    leading: Image.asset(item.product["image"]),
                    title: Text(item.product["name"]),
                    subtitle: Text("${item.product["price"]} руб."),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              cart.decreaseQuantity(item);
                            },
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cart.increaseQuantity(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartModel>(
        builder: (context, cart, child) {
          double totalPrice = cart.items.fold(0, (sum, item) => sum + item.product["price"] * item.quantity);
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Итого: $totalPrice руб.",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Реализуйте оплату или другой функционал
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Функционал оплаты не реализован")),
                    );
                  },
                  child: const Text("Оформить заказ"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
