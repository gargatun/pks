import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магазин Здорового Питания',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.green),
          bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black87),
          titleMedium: TextStyle(fontSize: 16.0, color: Colors.black54),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
