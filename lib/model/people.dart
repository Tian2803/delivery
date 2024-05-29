class People {
  final String name;
  final String lastName;
  final String phone;
  final String streetAddress;
  final String email;
  final String profileImage;
  final String id;

  People({
    required this.name,
    required this.lastName,
    required this.phone,
    required this.streetAddress,
    required this.email,
    required this.profileImage,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'streetAddress': streetAddress,
      'email': email,
      'profileImage': profileImage,
      'id': id,
    };
  }
}