// lib/models/cart_model.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../navigator_key.dart'; // Импортируем navigatorKey

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  Future<void> fetchCartItems() async {
    try {
      _items = await ApiService.getAllCartItems();
      notifyListeners();
    } catch (e) {
      // Обработка ошибок
      print(e);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при получении корзины: $e')),
      );
    }
  }

  void addItem(Product product) async {
    try {
      print('Adding product to cart: ${product.toJson()}');
      await ApiService.addToCart(product.id!, 1);
      await fetchCartItems();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('${product.name} добавлен(а) в корзину')),
      );
    } catch (e) {
      print('Error in addItem: $e');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении в корзину: $e')),
      );
    }
  }

  void removeItem(Product product) async {
    try {
      await ApiService.removeFromCart(product.id!);
      await fetchCartItems();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('${product.name} удален(а) из корзины')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении из корзины: $e')),
      );
    }
  }

  void increaseQuantity(CartItem item) async {
    try {
      await ApiService.increaseCartItem(item.product.id!);
      await fetchCartItems();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Количество ${item.product.name} увеличено')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при увеличении количества: $e')),
      );
    }
  }

  void decreaseQuantity(CartItem item) async {
    try {
      await ApiService.decreaseCartItem(item.product.id!);
      await fetchCartItems();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Количество ${item.product.name} уменьшено')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при уменьшении количества: $e')),
      );
    }
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
}
