import 'package:delivery/model/people.dart';

class Customer extends People {
  final String
      deliveryPreference; //omo recogida en tienda, entrega a domicilio, puntos de recogida
  Customer(
    String name,
    String lastName,
    String phone,
    String streetAddress,
    String email,
    String profileImage,
    String id,
    this.deliveryPreference,
  ) : super(
          name: name,
          lastName: lastName,
          phone: phone,
          streetAddress: streetAddress,
          email: email,
          profileImage: profileImage,
          id: id,
        );

  Customer.defaultConstructor()
      : deliveryPreference = 'Home Delivery',
        super(
          name: 'none',
          lastName: 'none',
          phone: 'none',
          streetAddress: 'none',
          email: 'none',
          profileImage:
              'https://t3.ftcdn.net/jpg/02/99/21/98/360_F_299219888_2E7GbJyosu0UwAzSGrpIxS0BrmnTCdo4.jpg',
          id: 'none',
        );

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map['deliveryPreference'] = deliveryPreference;
    return map;
  }

  // Create a Product instance from JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      json['name'],
      json['lastName'],
      json['phone'],
      json['streetAddress'],
      json['email'],
      json['profileImage'],
      json['id'],
      json['deliveryPreference'],
    );
  }
}
