import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  bool showFavs;

  ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productList = showFavs ? productsData.favItems : productsData.items;
    return GridView.builder(
      itemCount: productList.length,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        //create: (context) => productList[index],
        value: productList[
            index], // this is another apporach to use changenotifierprovider when we dont acutally need to use the context we can simply use the .value and give value directly (mostly used when objects are reused)
        child: ProductItem(
            // id: productList[index].id,
            // title: productList[index].title,
            // imageUrl: productList[index].imageUrl,
            ),
      ),
    );
  }
}
