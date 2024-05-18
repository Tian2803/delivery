// ignore_for_file: avoid_print

import 'package:delivery/model/cart.dart';
import 'package:flutter/material.dart';

class ShoppingController extends ChangeNotifier {
  // lista de productos
  List<Cart> _listProductsPurchased = [];
  List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products {
    // Mapear los elementos de _listProductsPurchased a la lista de Mapas
    _products = _listProductsPurchased.map((product) {
      return {
        'id': product.productId,
        'name': product.product,
        'price': product.price,
        'quantity': product.quantity,
        'ownerId': product.ownerId,
        'imageUrl': product.image
      };
    }).toList();

    return _products;
  }

  void clearProducts() {
    _listProductsPurchased.clear();
    print(_listProductsPurchased.length);
  }

  List<Cart> get listProductsPurchased {
    return _listProductsPurchased;
  }

  set selectedMenuOption(List<Cart> list) {
    _listProductsPurchased = list;
    notifyListeners();
  }

  double total(List listProducts) {
    double total = 0;
    for (var i = 0; i < listProducts.length; i++) {
      total += listProducts[i].price * listProducts[i].quantity;
    }

    return total;
  }
}
