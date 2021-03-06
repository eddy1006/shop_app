import 'package:flutter/cupertino.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSet() async {
    try {
      var url = Uri.parse(
          'https://shop-app-f4d83-default-rtdb.firebaseio.com/products.json');
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> prodList = [];
      extractedData.forEach((prodId, prodData) {
        prodList.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = prodList;
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> add_item(Product product) async {
    var url = Uri.parse(
        'https://shop-app-f4d83-default-rtdb.firebaseio.com/products.json');
    // return http                                    this is the approach we use when we are not using async with a function.
    //     .post(url,
    //         body: json.encode({
    //           'title': product.title,
    //           'description': product.description,
    //           'price': product.price,
    //           'imageUrl': product.imageUrl,
    //           'isFavorite': product.isFavorite,
    //         }))
    //     .then((respnose) {
    //   print(json.decode(respnose.body));
    //   final newProduct = Product(
    //       id: json.decode(respnose.body)['name'],
    //       title: product.title,
    //       description: product.description,
    //       price: product.price,
    //       imageUrl: product.imageUrl);
    //   _items.add(newProduct);
    //   notifyListeners();
    // }).catchError((error) {
    //   print(error);
    //   throw error;
    // });
    //_items.insert(0, newProduct); // inserts the element at the given index
    try {
      final response =
          await http //basic idea is that if we use then() then the compiler skips that part and continues to execute next lines of code and then returns at last to see if its done or not
              .post(
                  url, // but with await it will wait untill the we receive the response and then we dont need then as we can then work like normal code works
                  body: json.encode({
                    'title': product.title,
                    'description': product.description,
                    'price': product.price,
                    'imageUrl': product.imageUrl,
                    'isFavorite': product.isFavorite,
                  }));
      print(json.decode(response.body));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final _prodIndex = _items.indexWhere((element) => element.id == id);
    if (_prodIndex >= 0) {
      var url = Uri.parse(
          'https://shop-app-f4d83-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[_prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    // final _existingProdIndex = _items.indexWhere((element) => element.id == id);  approach without using await and async
    // Product? _existingProd = _items.elementAt(_existingProdIndex);
    // var url = Uri.parse(
    //     'https://shop-app-f4d83-default-rtdb.firebaseio.com/products/$id');
    // http.delete(url).then((response) {
    //   if (response.statusCode >= 400) {
    //     // we have to check the response code in delete only but in post and get if this condition is true it automatically throws error and we dont have to do it manually
    //     throw HttpException('Could not delete the item');
    //   }
    //   _existingProd = null;
    // }).catchError((error) {
    //   _items.insert(_existingProdIndex, _existingProd!);
    //   notifyListeners();
    // });
    // _items.removeWhere((element) => element.id == id);
    // notifyListeners();

    final _existingProdIndex = _items.indexWhere((element) => element.id == id);
    Product? _existingProd = _items.elementAt(_existingProdIndex);
    _items.removeAt(_existingProdIndex);
    notifyListeners();
    var url = Uri.parse(
        'https://shop-app-f4d83-default-rtdb.firebaseio.com/products/$id.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // we have to check the response code in delete only but in post and get if this condition is true it automatically throws error and we dont have to do it manually
      _items.insert(_existingProdIndex, _existingProd);
      notifyListeners();
      throw HttpException('Could not delete the item');
    }
    _existingProd = null;
  }
}
