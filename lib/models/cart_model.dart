// lib/models/cart_model.dart

import 'package:flutter/material.dart';

class CartItem {
  final Map<String, dynamic> product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Map<String, dynamic> product) {
    for (var item in _items) {
      if (item.product["name"] == product["name"]) {
        item.quantity += 1;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void removeItem(Map<String, dynamic> product) {
    _items.removeWhere((item) => item.product["name"] == product["name"]);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
}
