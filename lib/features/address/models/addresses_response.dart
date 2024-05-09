class AddressesResponse {
  final List<Address> results;
  final Info info;

  AddressesResponse({
    required this.results,
    required this.info,
  });

  factory AddressesResponse.fromJson(Map<String, dynamic> json) =>
      AddressesResponse(
        results:
            List<Address>.from(json["results"].map((x) => Address.fromJson(x))),
        info: Info.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "info": info.toJson(),
      };
}

class Info {
  final int perPage;
  final int currentPage;
  final int lastPage;

  Info({
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        perPage: json["per_page"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "per_page": perPage,
        "current_page": currentPage,
        "last_page": lastPage,
      };
}

class Address {
  final int id;
  final User user;
  final String address;
  final String name;
  final String detail;
  final String phone;
  final bool primary;
  final String? references;
  final DateTime createdAt;

  Address({
    required this.id,
    required this.user,
    required this.address,
    required this.name,
    required this.detail,
    required this.phone,
    required this.primary,
    required this.references,
    required this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        user: User.fromJson(json["user"]),
        address: json["address"],
        name: json["name"],
        detail: json["detail"],
        phone: json["phone"],
        primary: json["primary"],
        references: json["references"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "address": address,
        "name": name,
        "detail": detail,
        "phone": phone,
        "primary": primary,
        "references": references,
        "created_at": createdAt.toIso8601String(),
      };
}

class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
