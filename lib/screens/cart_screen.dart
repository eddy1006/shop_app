import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart!'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: const Text('ORDER NOW'),
                    onPressed: () {},
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
