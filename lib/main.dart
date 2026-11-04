import 'package:flutter/material.dart';
import 'screens/product_search_screen.dart';

void main() {
  runApp(const ProductSearchApp());
}

/// Root widget of the Product Search and Filter Application.
class ProductSearchApp extends StatelessWidget {
  const ProductSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Search & Filter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ProductSearchScreen(),
    );
  }
}
