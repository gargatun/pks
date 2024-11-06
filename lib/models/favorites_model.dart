// lib/models/favorites_model.dart

import 'package:flutter/material.dart';

class FavoritesModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void addFavorite(Map<String, dynamic> product) {
    _favorites.add(product);
    notifyListeners();
  }

  void removeFavorite(Map<String, dynamic> product) {
    _favorites.removeWhere((item) => item["name"] == product["name"]);
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> product) {
    return _favorites.any((item) => item["name"] == product["name"]);
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
