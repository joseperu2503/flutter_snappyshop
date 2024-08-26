class GeocodeResponse {
  final String address;
  final String country;
  final String locality;
  final String postalCode;
  final String plusCode;

  GeocodeResponse({
    required this.address,
    required this.country,
    required this.locality,
    required this.postalCode,
    required this.plusCode,
  });

  factory GeocodeResponse.fromJson(Map<String, dynamic> json) =>
      GeocodeResponse(
        address: json["address"],
        country: json["country"],
        locality: json["locality"],
        postalCode: json["postal_code"],
        plusCode: json["plus_code"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "country": country,
        "locality": locality,
        "postal_code": postalCode,
        "plus_code": plusCode,
      };
}
