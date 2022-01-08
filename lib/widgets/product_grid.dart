import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productList = productsData.items;
    return GridView.builder(
      itemCount: productList.length,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ProductItem(
        id: productList[index].id,
        title: productList[index].title,
        imageUrl: productList[index].imageUrl,
      ),
    );
  }
}
