class StoresResponse {
  final List<Store> results;
  final Info info;

  StoresResponse({
    required this.results,
    required this.info,
  });

  factory StoresResponse.fromJson(Map<String, dynamic> json) => StoresResponse(
        results:
            List<Store>.from(json["results"].map((x) => Store.fromJson(x))),
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
  final int total;

  Info({
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        perPage: json["per_page"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "per_page": perPage,
        "current_page": currentPage,
        "last_page": lastPage,
        "total": total,
      };
}

class Store {
  final int id;
  final String name;
  final String? description;
  final String? website;
  final String? email;
  final String? phone;
  final String? facebook;
  final String? instagram;
  final String? logotype;
  final String? isotype;
  final String? backdrop;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.website,
    required this.email,
    required this.phone,
    required this.facebook,
    required this.instagram,
    required this.logotype,
    required this.isotype,
    required this.backdrop,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        website: json["website"],
        email: json["email"],
        phone: json["phone"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        logotype: json["logotype"],
        isotype: json["isotype"],
        backdrop: json["backdrop"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "website": website,
        "email": email,
        "phone": phone,
        "facebook": facebook,
        "instagram": instagram,
        "logotype": logotype,
        "isotype": isotype,
        "backdrop": backdrop,
      };
}
