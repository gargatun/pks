// lib/models/product_model.dart

class Product {
  int? id;
  String name;
  double price;
  String image;
  bool organic;
  String category;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.organic,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('Parsing product: $json');
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      image: json['image'],
      organic: json['organic'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'price': price,
      'image': image,
      'organic': organic,
      'category': category,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
