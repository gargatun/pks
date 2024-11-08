// lib/models/favorites_model.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../navigator_key.dart'; // Импортируем navigatorKey

class FavoritesModel extends ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  Future<void> fetchFavorites() async {
    try {
      _favorites = await ApiService.getAllFavorites();
      notifyListeners();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при получении избранного: $e')),
      );
    }
  }

  void addFavorite(Product product) async {
    try {
      await ApiService.addToFavorites(product.id!);
      await fetchFavorites();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('${product.name} добавлен(а) в избранное')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении в избранное: $e')),
      );
    }
  }

  void removeFavorite(Product product) async {
    try {
      await ApiService.removeFromFavorites(product.id!);
      await fetchFavorites();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('${product.name} удален(а) из избранного')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении из избранного: $e')),
      );
    }
  }

  bool isFavorite(Product product) {
    return _favorites.any((item) => item.id == product.id);
  }
}
