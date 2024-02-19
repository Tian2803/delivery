class Cart {
  final String product;
  final int quantity;
  final String price;
  final String image;

  Cart(
      {required this.product,
      required this.quantity,
      required this.price,
      required this.image});

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'quantity': quantity,
      'price': price,
      'image': image
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        product: json['product'],
        quantity: json['quantity'],
        price: json['price'],
        image: json['image']);
  }
}
