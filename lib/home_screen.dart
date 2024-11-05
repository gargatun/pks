import 'package:flutter/material.dart';
import 'product_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "Замула";
  final String userSurname = "Матвей ЭФБО-04-22";
  final List<Map<String, dynamic>> products = [
    {"name": "Органическое яблоко", "price": 10, "image": "assets/apple.png"},
    {"name": "Свежий апельсин", "price": 20, "image": "assets/orange.png"},
    {"name": "Банан", "price": 12, "image": "assets/banana.png"},
  ];

  final List<Map<String, dynamic>> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Магазин Здорового Питания"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: cartItems),
                ),
              );
            },
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
              style: Theme.of(context).textTheme.titleLarge, // заменили headline6 на titleLarge
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
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
