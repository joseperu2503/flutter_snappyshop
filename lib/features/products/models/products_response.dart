class ProductsResponse {
  final List<Product> data;
  final Links links;
  final Meta meta;

  ProductsResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> images;
  final Brand? brand;
  final Category? category;
  final List<String> colors;
  final List<Size> sizes;
  final List<Gender> genders;
  final bool freeShipping;
  final User user;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.brand,
    required this.category,
    required this.colors,
    required this.sizes,
    required this.genders,
    required this.freeShipping,
    required this.user,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        stock: json["stock"],
        images: List<String>.from(json["images"].map((x) => x)),
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        colors: List<String>.from(json["colors"].map((x) => x)),
        sizes: List<Size>.from(json["sizes"].map((x) => Size.fromJson(x))),
        genders:
            List<Gender>.from(json["genders"].map((x) => Gender.fromJson(x))),
        freeShipping: json["free_shipping"],
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["created_at"]),
      );
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
}

class Brand {
  final int id;
  final String name;

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
      );
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );
}

class Size {
  final int id;
  final String name;

  Size({
    required this.id,
    required this.name,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json["id"],
        name: json["name"],
      );
}

class Gender {
  final int id;
  final String name;

  Gender({
    required this.id,
    required this.name,
  });

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        id: json["id"],
        name: json["name"],
      );
}

class Links {
  final String first;
  final String last;
  final dynamic prev;
  final String next;

  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );
}

class Meta {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<Link> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );
}
