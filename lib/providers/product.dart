import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourite(String tokenId,String userId) async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    var url = Uri.https(
        'flutter-update-8afd8-default-rtdb.firebaseio.com', '/userFavourites/$userId/$id.json',{'auth' : tokenId});
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldstatus;
      }
    } catch (error) {
      isFavourite = oldstatus;
    }
    notifyListeners();
  }
}
