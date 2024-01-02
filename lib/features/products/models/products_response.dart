class ProductsResponse {
  final List<Product> data;
  final Meta meta;

  ProductsResponse({
    required this.data,
    required this.meta,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        data: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
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
  final _Brand? brand;
  final _Category? category;
  final List<String> colors;
  final List<Size> sizes;
  final List<Gender> genders;
  final bool freeShipping;
  final User user;
  final DateTime createdAt;
  final int? discount;

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
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        stock: json["stock"],
        images: List<String>.from(json["images"].map((x) => x)),
        brand: json["brand"] == null ? null : _Brand.fromJson(json["brand"]),
        category: json["category"] == null
            ? null
            : _Category.fromJson(json["category"]),
        colors: List<String>.from(json["colors"].map((x) => x)),
        sizes: List<Size>.from(json["sizes"].map((x) => Size.fromJson(x))),
        genders:
            List<Gender>.from(json["genders"].map((x) => Gender.fromJson(x))),
        freeShipping: json["free_shipping"],
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["created_at"]),
        discount: json["discount"],
      );
}

class User {
  final int id;
  final String name;
  final String email;
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );
}

class _Brand {
  final int id;
  final String name;

  _Brand({
    required this.id,
    required this.name,
  });

  factory _Brand.fromJson(Map<String, dynamic> json) => _Brand(
        id: json["id"],
        name: json["name"],
      );
}

class _Category {
  final int id;
  final String name;

  _Category({
    required this.id,
    required this.name,
  });

  factory _Category.fromJson(Map<String, dynamic> json) => _Category(
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

class Meta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );
}
