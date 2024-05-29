import 'package:delivery/model/people.dart';

class Owner extends People {
  final String company;
  Owner(String name, String lastName, String phone, String streetAddress,
      String email, String profileImage, String id, this.company)
      : super(
            name: name,
            lastName: lastName,
            phone: phone,
            streetAddress: streetAddress,
            email: email,
            profileImage: profileImage,
            id: id);

  Owner.defaultConstructor()
      : company = 'none',
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
  // Convert Product to JSON
  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map['company'] = company;
    return map;
  }

  // Convert JSON to Owner object
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      json['name'],
      json['lastName'],
      json['phone'],
      json['streetAddress'],
      json['email'],
      json['profileImage'],
      json['id'],
      json['company'],
    );
  }
}
