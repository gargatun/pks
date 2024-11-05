import 'package:flutter/material.dart';
import 'product_screen.dart';
import 'filter_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "Замула";
  final String userSurname = "Матвей";
  final List<Map<String, dynamic>> products = [
    {"name": "Органическое яблоко", "price": 15, "image": "assets/apple.png", "organic": true, "category": "Фрукты"},
    {"name": "Свежий апельсин", "price": 20, "image": "assets/orange.png", "organic": true, "category": "Фрукты"},
    {"name": "Банан", "price": 12, "image": "assets/banana.png", "organic": false, "category": "Фрукты"},
  ];

  final List<Map<String, dynamic>> cartItems = [];
  bool organicOnly = false;
  String selectedCategory = "Фрукты";

  void applyFilter(bool organic, String category) {
    setState(() {
      organicOnly = organic;
      selectedCategory = category;
    });
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((product) {
      final matchesOrganic = !organicOnly || product["organic"] == true;
      final matchesCategory = product["category"] == selectedCategory;
      return matchesOrganic && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Магазин Здорового Питания"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterScreen(
                    currentOrganicOnly: organicOnly,
                    currentCategory: selectedCategory,
                    onApplyFilter: applyFilter,
                  ),
                ),
              );
            },
            tooltip: 'Фильтр продуктов',
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems)),
              );
            },
            tooltip: 'Корзина',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Добро пожаловать, $userName $userSurname",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(product["image"]),
                    title: Text(product["name"]),
                    subtitle: Text("${product["price"]} руб."),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            product: product,
                            addToCart: () {
                              setState(() {
                                cartItems.add(product);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
