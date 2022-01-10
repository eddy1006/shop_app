import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFvourite() async {
    final oldstatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var url = Uri.parse(
          'https://shop-app-f4d83-default-rtdb.firebaseio.com/products/$id.json');
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldstatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldstatus;
      notifyListeners();
    }
  }
}
