import 'package:flutter/material.dart';
import 'package:practise_app/model/product.dart';
import 'package:practise_app/ui/screens/add_product_screen.dart';
import 'package:practise_app/ui/screens/product_list_screen.dart';
import 'package:practise_app/ui/screens/update_product_screen.dart';

class CRUDApp extends StatelessWidget {
  const CRUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        late Widget widget;
        if (settings.name == '/') {
          widget = const ProductListScreen();
        } else if (settings.name == AddNewProductScreen.name) {
          widget = const AddNewProductScreen();
        } else if (settings.name == UpdateProductScreen.name) {
          final Product product = settings.arguments as Product;
          widget = UpdateProductScreen(product: product);
        }

        return MaterialPageRoute(
          builder: (context) {
            return widget;
          },
        );
      },
      theme: _buildThemeData(),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(size: 30, color: Colors.white),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: Colors.deepOrangeAccent.withOpacity(0.3),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          color: Colors.black,
        ),
        subtitleTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: Colors.black,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        iconSize: 40,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
