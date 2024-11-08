// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_list_item.dart';
import '../widgets/product_grid_item.dart';
import 'filter_screen.dart' as filter;
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import 'add_product_screen.dart'; // Импортируем экран добавления продукта
import 'package:google_fonts/google_fonts.dart';

enum ViewType { list, grid }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];

  bool organicOnly = false;
  String selectedCategory = "Фрукты";
  ViewType viewType = ViewType.list;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void applyFilter(bool organic, String category) {
    setState(() {
      organicOnly = organic;
      selectedCategory = category;
    });
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      List<Product> fetchedProducts = await ApiService.getAllProducts(
        organicOnly: organicOnly,
        category: selectedCategory,
      );
      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesOrganic = !organicOnly || product.organic == true;
      final matchesCategory = product.category == selectedCategory;
      return matchesOrganic && matchesCategory;
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Добро пожаловать!",
            style: GoogleFonts.openSans(
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: viewType == ViewType.list
                ? ListView.builder(
              key: const ValueKey<ViewType>(ViewType.list),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductListItem(product: product);
              },
            )
                : GridView.builder(
              key: const ValueKey<ViewType>(ViewType.grid),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductGridItem(product: product);
              },
            ),
          ),
        ),
      ],
    );
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
                    onApplyFilter: applyFilter, // Используем типизированный колбэк
                  ),
                ),
              );
            },
            tooltip: 'Фильтр продуктов',
          ),
          IconButton(
            icon: Icon(viewType == ViewType.list ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                viewType = viewType == ViewType.list ? ViewType.grid : ViewType.list;
              });
            },
            tooltip: viewType == ViewType.list ? 'Переключиться на сетку' : 'Переключиться на список',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              );
              if (result == true) {
                // Если продукт был добавлен, обновить список
                fetchProducts();
              }
            },
            tooltip: 'Добавить продукт',
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2; // Перейти на вкладку "Корзина"
                  });
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return cart.itemCount > 0
                        ? CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHome(),
          const FavoritesScreen(),
          const CartScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.openSans(),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
