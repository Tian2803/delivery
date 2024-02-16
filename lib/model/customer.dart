class Customer {
  final String customerName;
  final String customerLastName;
  final String customerPhone;
  final String customerStreetAddress;
  final String customerEmail;
  final String customerProfile;
  final String customerId;

  Customer(
      {required this.customerName,
      required this.customerLastName,
      required this.customerPhone,
      required this.customerStreetAddress,
      required this.customerEmail,
      required this.customerProfile,
      required this.customerId});

  Customer.defaultConstructor()
      : customerName = 'none',
        customerLastName = 'none',
        customerPhone = 'none',
        customerStreetAddress = 'none',
        customerEmail = 'none',
        customerProfile =
            'https://t3.ftcdn.net/jpg/02/99/21/98/360_F_299219888_2E7GbJyosu0UwAzSGrpIxS0BrmnTCdo4.jpg',
        customerId = 'none';

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerLastName': customerLastName,
      'customerPhone': customerPhone,
      'customerStreetAddress': customerStreetAddress,
      'customerEmail': customerEmail,
      'customerProfile': customerProfile,
      'customerId': customerId,
    };
  }

  // Create a Product instance from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerName: json['customerName'],
      customerLastName: json['customerLastName'],
      customerPhone: json['customerPhone'],
      customerStreetAddress: json['customerStreetAddress'],
      customerEmail: json['customerEmail'],
      customerProfile: json['customerProfile'],
      customerId: json['customerId'],
    );
  }
}
