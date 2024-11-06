// lib/widgets/product_grid_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_screen.dart';
import '../models/cart_model.dart';
import '../models/favorites_model.dart';
import 'package:google_fonts/google_fonts.dart'; // Импортируем Google Fonts

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Увеличили скругление
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  product["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0), // Увеличили отступы
              child: Text(
                product["name"],
                style: GoogleFonts.openSans(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "${product["price"]} руб.",
                style: GoogleFonts.openSans(
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    color: Colors.green,
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
                      color: isFavorite ? Colors.red : Colors.grey,
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
            ),
          ],
        ),
      ),
    );
  }
}
