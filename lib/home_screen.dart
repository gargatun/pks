import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_screen.dart';
import 'filter_screen.dart' as filter;  // Алиас для экрана фильтрации
import 'cart_screen.dart';
import 'cart_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "Матвей";
  final String userSurname = "Замула";
  final List<Map<String, dynamic>> products = [
    {"name": "Органическое яблоко", "price": 15, "image": "assets/apple.png", "organic": true, "category": "Фрукты"},
    {"name": "Свежий апельсин", "price": 20, "image": "assets/orange.png", "organic": true, "category": "Фрукты"},
    {"name": "Банан", "price": 12, "image": "assets/banana.png", "organic": false, "category": "Фрукты"},
  ];

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
        title: const Text("Магазин Здорового Питания"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => filter.FilterScreen(
                    currentOrganicOnly: organicOnly,
                    currentCategory: selectedCategory,
                    onApplyFilter: applyFilter,
                  ),
                ),
              );
            },
            tooltip: 'Фильтр продуктов',
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
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
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Image.asset(product["image"]),
                    title: Text(product["name"]),
                    subtitle: Text("${product["price"]} руб."),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Provider.of<CartModel>(context, listen: false).addItem(product);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            product: product,
                            addToCart: () {
                              Provider.of<CartModel>(context, listen: false).addItem(product);
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
