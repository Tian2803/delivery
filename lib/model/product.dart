class Product {
  final String productName;
  final double productPrice;
  final String productImage;
  final int productQuantity;
  final String description;
  final String category;
  final String preparationTime;
  final String productId;
  final String userId;

  Product({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productQuantity,
    required this.description,
    required this.category,
    required this.preparationTime,
    required this.productId,
    required this.userId
  });

   Product.defaultConstructor()
      : productName = 'none',
        productPrice = 0.0,
        productImage =
            'https://t3.ftcdn.net/jpg/02/99/21/98/360_F_299219888_2E7GbJyosu0UwAzSGrpIxS0BrmnTCdo4.jpg',
        productQuantity = 0,
        description = 'none',
        category = 'none',
        preparationTime = '0',
        productId = 'none',
        userId = 'none';

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'productQuantity': productQuantity,
      'description': description,
      'category': category,
      'preparationTime': preparationTime,
      'productId': productId,
      'userId': userId,
    };
  }

  // Create a Product instance from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'],
      productPrice: json['productPrice'],
      productImage: json['productImage'],
      productQuantity: json['productQuantity'],
      description: json['description'],
      category: json['category'],
      preparationTime: json['preparationTime'],
      productId: json['productId'],
      userId: json['userId'],
    );
  }
}
