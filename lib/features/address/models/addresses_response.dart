class Address {
  final int id;
  final String address;
  final String detail;
  final String phone;
  final String recipientName;
  final String? references;
  final double latitude;
  final double longitude;
  final bool adressDefault;
  final String country;
  final String locality;
  final String plusCode;
  final String postalCode;

  Address({
    required this.id,
    required this.address,
    required this.detail,
    required this.phone,
    required this.recipientName,
    required this.references,
    required this.latitude,
    required this.longitude,
    required this.adressDefault,
    required this.country,
    required this.locality,
    required this.plusCode,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        address: json["address"],
        detail: json["detail"],
        phone: json["phone"],
        recipientName: json["recipient_name"],
        references: json["references"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        adressDefault: json["default"],
        country: json["country"],
        locality: json["locality"],
        plusCode: json["plus_code"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "detail": detail,
        "phone": phone,
        "recipient_name": recipientName,
        "references": references,
        "latitude": latitude,
        "longitude": longitude,
        "default": adressDefault,
        "country": country,
        "locality": locality,
        "plus_code": plusCode,
        "postal_code": postalCode,
      };
}
