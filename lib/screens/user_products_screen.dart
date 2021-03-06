import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_products_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _fetchOnrefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _fetchOnrefresh(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                    products[i].id!, products[i].title, products[i].imageUrl),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
