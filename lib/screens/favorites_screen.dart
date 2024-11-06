// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorites_model.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_list_item.dart';

enum ViewType { list, grid }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  ViewType viewType = ViewType.grid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Избранное"),
        actions: [
          IconButton(
            icon: Icon(viewType == ViewType.list ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                viewType = viewType == ViewType.list ? ViewType.grid : ViewType.list;
              });
            },
            tooltip: viewType == ViewType.list ? 'Сетка' : 'Список',
          ),
        ],
      ),
      body: Consumer<FavoritesModel>(
        builder: (context, favorites, child) {
          if (favorites.favorites.isEmpty) {
            return const Center(
              child: Text("У вас пока нет избранных товаров."),
            );
          }
          return viewType == ViewType.list
              ? ListView.builder(
            itemCount: favorites.favorites.length,
            itemBuilder: (context, index) {
              final product = favorites.favorites[index];
              return ProductListItem(product: product);
            },
          )
              : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: favorites.favorites.length,
            itemBuilder: (context, index) {
              final product = favorites.favorites[index];
              return ProductGridItem(product: product);
            },
          );
        },
      ),
    );
  }
}
