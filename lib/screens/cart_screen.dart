// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import 'package:google_fonts/google_fonts.dart'; // Импортируем Google Fonts

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Корзина"),
        elevation: 0,
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(item.product["image"], width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(
                      item.product["name"],
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      "${item.product["price"]} руб.",
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.green,
                            onPressed: () {
                              cart.decreaseQuantity(item);
                            },
                          ),
                          Text(
                            '${item.quantity}',
                            style: GoogleFonts.openSans(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Colors.green,
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
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Итого: $totalPrice руб.",
                  style: GoogleFonts.openSans(
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Реализуйте оплату или другой функционал
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Функционал оплаты не реализован")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
