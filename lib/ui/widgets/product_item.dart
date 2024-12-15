import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practise_app/model/product.dart';
import 'package:practise_app/ui/screens/update_product_screen.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.getProductList,
  });

  final Product product;
  final Function getProductList;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _deleteInProgress = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        widget.product.image ?? '',
        width: 40,
        height: 40,
        errorBuilder: (context, child, stackTrace) {
          return const Icon(Icons.downloading);
        },
      ),
      title: Text(widget.product.productName ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${widget.product.productCode ?? 'Unknown'}'),
          Text('Quantity: ${widget.product.quantity ?? 'Unknown'}'),
          Text('Price: ${widget.product.unitPrice ?? 'Unknown'}'),
          Text('Total Price: ${widget.product.totalPrice ?? 'Unknown'}'),
        ],
      ),
      trailing: Wrap(
        children: [
          Visibility(
            visible: _deleteInProgress == false,
            replacement: const CircularProgressIndicator(),
            child: IconButton(
              onPressed: () {
                _deleteProduct(
                  productID: widget.product.id.toString(),
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.name,
                arguments: widget.product,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct({required String productID}) async {
    _deleteInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productID');
    Response response = await get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      debugPrint(decodedData['status'].toString());
      widget.getProductList();
      setState(() {});

      if (mounted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product has been deleted!'),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product has not been deleted!'),
          ),
        );
      }
    }
    _deleteInProgress = false;
    setState(() {});
  }
}
