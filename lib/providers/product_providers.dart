// ignore: unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  final String _token;
  final String userId;
  Products(this._token, this.userId, this._items);
  List<Product> _items = [];

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndStoreProducts([bool filterWithrespecttoUser = false]) async {
    // ignore: unused_local_variable
    final filterString = filterWithrespecttoUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    var url = Uri.https(
        'flutter-update-8afd8-default-rtdb.firebaseio.com', '/products.json', {
      'auth': _token,
      'orderBy': "\"creatorId\"",
      'equalTo': "\"$userId\"",
    });
    var url2 = Uri.https('flutter-update-8afd8-default-rtdb.firebaseio.com',
        '/products.json', {'auth': _token});
    url = filterWithrespecttoUser ? url : url2;
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url = Uri.https(
        'flutter-update-8afd8-default-rtdb.firebaseio.com',
        '/userFavourites/$userId.json',
        {'auth': _token},
      );
      final favRespone = await http.get(url);
      final favData = json.decode(favRespone.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodct) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodct['title'],
          description: prodct['description'],
          price: double.parse(prodct['price'].toString()),
          imageUrl: prodct['imageUrl'],
          isFavourite: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('ffdfdf');
      rethrow;
    }
  }

  Future<void> addProducts(Product product) async {
    var url = Uri.https('flutter-update-8afd8-default-rtdb.firebaseio.com',
        '/products.json', {'auth': _token});
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final indexId = _items.indexWhere((element) => element.id == id);
    var url = Uri.https('flutter-update-8afd8-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': _token});
    await http.patch(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavourite': product.isFavourite,
        }));
    if (indexId >= 0) {
      _items[indexId] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.https('flutter-update-8afd8-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': _token});
    http.delete(url).then((value) {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
    });
  }
}
