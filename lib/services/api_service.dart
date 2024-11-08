// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/cart_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8001';

  // Получение всех продуктов с возможностью фильтрации
  static Future<List<Product>> getAllProducts({bool? organicOnly, String? category}) async {
    String url = '$baseUrl/products';
    Map<String, String> params = {};
    if (organicOnly != null) params['organic'] = organicOnly.toString();
    if (category != null) params['category'] = category;
    if (params.isNotEmpty) {
      url += '?' + Uri(queryParameters: params).query;
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка при получении продуктов');
    }
  }

  // Добавление нового продукта
  static Future<Product> addNewProduct(Product product) async {
    print('Вызов метода addNewProduct с продуктом: ${product.toJson()}');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(product.toJson()),
      );

      print('Request body: ${json.encode(product.toJson())}');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Product.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Ошибка при добавлении продукта: ${response.statusCode}');
      }
    } catch (e) {
      print('Исключение в addNewProduct: $e');
      rethrow; // Пробрасываем исключение дальше для обработки в месте вызова
    }
  }

  // Методы для корзины
  static Future<List<CartItem>> getAllCartItems() async {
    final response = await http.get(Uri.parse('$baseUrl/cart'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CartItem.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка при получении корзины');
    }
  }

  static Future<void> addToCart(int productId, int quantity) async {
    try {
      print('Sending addToCart request with productId: $productId, quantity: $quantity');
      final response = await http.post(
        Uri.parse('$baseUrl/cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': productId, 'quantity': quantity}),
      );

      print('Add to cart response status: ${response.statusCode}');
      print('Add to cart response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Ошибка при добавлении в корзину: ${response.body}');
      }
    } catch (e) {
      print('Исключение в addToCart: $e');
      rethrow;
    }
  }

  static Future<void> removeFromCart(int productId) async {
    final response = await http.delete(Uri.parse('$baseUrl/cart/$productId'));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении из корзины');
    }
  }

  static Future<void> increaseCartItem(int productId) async {
    final response = await http.post(Uri.parse('$baseUrl/cart/$productId/increase'));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при увеличении количества');
    }
  }

  static Future<void> decreaseCartItem(int productId) async {
    final response = await http.post(Uri.parse('$baseUrl/cart/$productId/decrease'));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при уменьшении количества');
    }
  }

  // Методы для избранного
  static Future<List<Product>> getAllFavorites() async {
    final response = await http.get(Uri.parse('$baseUrl/favorites'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item['product'])).toList();
    } else {
      throw Exception('Ошибка при получении избранного');
    }
  }

  static Future<void> addToFavorites(int productId) async {
    try {
      print('Sending addToFavorites request with productId: $productId');
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': productId}),
      );

      print('Add to favorites response status: ${response.statusCode}');
      print('Add to favorites response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Ошибка при добавлении в избранное: ${response.body}');
      }
    } catch (e) {
      print('Исключение в addToFavorites: $e');
      rethrow;
    }
  }

  static Future<void> removeFromFavorites(int productId) async {
    final response = await http.delete(Uri.parse('$baseUrl/favorites/$productId'));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении из избранного');
    }
  }
}
