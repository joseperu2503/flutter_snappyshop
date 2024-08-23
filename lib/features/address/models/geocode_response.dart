class GeocodeResponse {
  final String latitude;
  final String longitude;
  final String address;

  GeocodeResponse({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory GeocodeResponse.fromJson(Map<String, dynamic> json) =>
      GeocodeResponse(
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
      };
}
