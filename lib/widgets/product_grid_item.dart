// lib/widgets/product_grid_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_screen.dart';
import '../models/cart_model.dart';
import '../models/favorites_model.dart';

class ProductGridItem extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool isFavorite = Provider.of<FavoritesModel>(context).isFavorite(product);

    return GestureDetector(
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
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                product["image"],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product["name"],
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "${product["price"]} руб.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
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
          ],
        ),
      ),
    );
  }
}
