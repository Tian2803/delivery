class Cart {
  final String product;
  int quantity;
  final double price;
  final String image;
  final String productId;
  final String ownerId;

  Cart(
      {required this.product,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.image,
      required this.ownerId});
}
