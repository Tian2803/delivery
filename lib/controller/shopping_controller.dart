import 'package:delivery/model/cart.dart';
import 'package:flutter/material.dart';

class ShoppingController extends ChangeNotifier {
  // lista de productos
  List<Cart> _listProductsPurchased = [];

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
      total +=
          listProducts[i].price * listProducts[i].quantity;
    }

    return total;
  }
}
