class Owner {
  final String ownerName;
  final String ownerLastName;
  final String ownerPhone;
  final String ownerStreetAddress;
  final String ownerEmail;
  final String ownerProfile;
  final String ownerId;

  Owner(
      {required this.ownerName,
      required this.ownerLastName,
      required this.ownerPhone,
      required this.ownerStreetAddress,
      required this.ownerEmail,
      required this.ownerProfile,
      required this.ownerId});

  Owner.defaultConstructor()
      : ownerName = 'none',
        ownerLastName = 'none',
        ownerPhone = 'none',
        ownerStreetAddress = 'none',
        ownerEmail = 'none',
        ownerProfile =
            'https://t3.ftcdn.net/jpg/02/99/21/98/360_F_299219888_2E7GbJyosu0UwAzSGrpIxS0BrmnTCdo4.jpg',
        ownerId = 'none';

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName,
      'ownerLastName': ownerLastName,
      'ownerPhone': ownerPhone,
      'ownerStreetAddress': ownerStreetAddress,
      'ownerEmail': ownerEmail,
      'ownerProfile': ownerProfile,
      'ownerId': ownerId,
    };
  }

  // Create a Product instance from JSON
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      ownerName: json['ownerName'],
      ownerLastName: json['ownerLastName'],
      ownerPhone: json['ownerPhone'],
      ownerStreetAddress: json['ownerStreetAddress'],
      ownerEmail: json['ownerEmail'],
      ownerProfile: json['ownerProfile'],
      ownerId: json['ownerId'],
    );
  }
}
