class DetailPayment {
  final String detailPaymentId;
  final String productId;
  final String ownerId;
  final String customerId;
  final String quantity;
  final String pay;
  final String date;
  final String state;

  DetailPayment({
    required this.detailPaymentId,
    required this.productId,
    required this.ownerId,
    required this.customerId,
    required this.quantity,
    required this.pay,
    required this.date,
    required this.state
  });

  factory DetailPayment.fromJson(Map<String, dynamic> json) {
    return DetailPayment(
      detailPaymentId: json['detailPaymentId'],
      productId: json['productId'],
      ownerId: json['ownerId'],
      customerId: json['customerId'],
      pay: json['pay'],
      quantity: json['quantity'],
      date: json['date'],
      state: json['state']
    );
  }

  Map<String, dynamic> toJson() => {
        'detailPaymentId': detailPaymentId,
        'productId': productId,
        'ownerId': ownerId,
        'customerId': customerId,
        'quantity': quantity,
        'pay': pay,
        'date': date,
        'state': state
      };
}
