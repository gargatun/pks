// lib/widgets/product_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_screen.dart';
import '../models/cart_model.dart';
import '../models/favorites_model.dart';

class ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool isFavorite = Provider.of<FavoritesModel>(context).isFavorite(product);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Image.asset(product["image"], width: 50, height: 50, fit: BoxFit.cover),
        title: Text(product["name"]),
        subtitle: Text("${product["price"]} руб."),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Provider.of<CartModel>(context, listen: false).addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product["name"]} добавлен(а) в корзину')),
                );
              },
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                if (isFavorite) {
                  Provider.of<FavoritesModel>(context, listen: false).removeFavorite(product);
                } else {
                  Provider.of<FavoritesModel>(context, listen: false).addFavorite(product);
                }
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductScreen(
                product: product,
                addToCart: () {
                  Provider.of<CartModel>(context, listen: false).addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product["name"]} добавлен(а) в корзину')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
