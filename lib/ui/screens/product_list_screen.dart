import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practise_app/model/product.dart';
import 'package:practise_app/ui/screens/add_product_screen.dart';
import 'package:practise_app/ui/widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _getProductListInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product list'),
        actions: [
          IconButton(
            onPressed: () {
              _getProductList();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            _getProductList();
          },
          child: Visibility(
            visible: _getProductListInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.separated(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ProductItem(
                  product: productList[index],
                  getProductList: _getProductList,
                );
              },
              separatorBuilder: (_,__){
                return const SizedBox(height: 8);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewProductScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    productList.clear();
    _getProductListInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      debugPrint(decodedData['status'].toString());
      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
          id: p['_id'],
          productName: p['ProductName'],
          productCode: p['ProductCode'],
          quantity: p['Qty'],
          unitPrice: p['UnitPrice'],
          image: p['Img'],
          totalPrice: p['TotalPrice'],
          createdDate: p['CreatedDate'],
        );
        productList.add(product);
      }
      setState(() {});
    }
    _getProductListInProgress = false;
    setState(() {});
  }
}
