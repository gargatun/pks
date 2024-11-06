// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'models/cart_model.dart';
import 'models/user_model.dart';
import 'models/favorites_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => FavoritesModel()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магазин Здорового Питания',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}
