import 'package:delivery/model/cart.dart';
import 'package:get/get.dart';

class ShoppingController extends GetxController {
  // lista de productos
  var entries = <Cart>[].obs;
  // el valor total de la compra
  var total = 0.obs;

  void agregarProductoALista(String product, String productId, int quantity,
      double price, String image) {
    entries.add(Cart(
        product: product,
        productId: productId,
        quantity: quantity,
        price: price,
        image: image));
        mostrarProductos();
  }
  
  void mostrarProductos() {
    print("Lista de productos:");
    entries.forEach((product) {
      print(
          "ID: ${product.productId}, Producto: ${product.product}, Cantidad: ${product.quantity}, Precio: ${product.price}, Imagen: ${product.image}");
    });
  }

  void calcularTotal() {
    int newTotal = 0;

    for (Cart product in entries) {
      newTotal = (newTotal + product.price * product.quantity) as int;
    }

    total.value = newTotal;
  }

  agregarProducto(id) {
    Cart product = entries.firstWhere((element) => id == element.productId);
    int index = entries.indexOf(product);
    product.quantity += 1;
    entries[index] = product;
    calcularTotal();
  }

  quitarProducto(id) {
    Cart product = entries.firstWhere((element) => id == element.productId);
    int index = entries.indexOf(product);
    if (product.quantity > 0) {
      product.quantity -= 1;
      entries[index] = product;
    }
    calcularTotal();
  }
}
