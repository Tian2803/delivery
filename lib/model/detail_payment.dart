class DetailPayment {
  final String detailPaymentId;
  final List<Map<String, dynamic>> products;
  final String customerId;
  final String pay;
  final String date;
  final String state;

  DetailPayment({
    required this.detailPaymentId,
    required this.products,
    required this.customerId,
    required this.pay,
    required this.date,
    required this.state
  });

  factory DetailPayment.fromJson(Map<String, dynamic> json) {
    return DetailPayment(
      detailPaymentId: json['detailPaymentId'],
      products: json['products'],
      customerId: json['customerId'],
      pay: json['pay'],
      date: json['date'],
      state: json['state']
    );
  }

  Map<String, dynamic> toJson() => {
        'detailPaymentId': detailPaymentId,
        'products': products,
        'customerId': customerId,
        'pay': pay,
        'date': date,
        'state': state
      };
}
