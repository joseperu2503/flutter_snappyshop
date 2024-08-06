class ProductsResponse {
  final List<Product> results;
  final Info info;

  ProductsResponse({
    required this.results,
    required this.info,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      ProductsResponse(
        results:
            List<Product>.from(json["results"].map((x) => Product.fromJson(x))),
        info: Info.fromJson(json["info"]),
      );
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

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> images;
  final ProductStore store;
  final ProductCategory category;
  final List<String> colors;
  final List<Size> sizes;
  final List<Gender> genders;
  final int? discount;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.store,
    required this.category,
    required this.colors,
    required this.sizes,
    required this.genders,
    required this.discount,
    required this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        stock: json["stock"],
        images: List<String>.from(json["images"].map((x) => x)),
        store: ProductStore.fromJson(json["store"]),
        category: ProductCategory.fromJson(json["category"]),
        colors: List<String>.from(json["colors"].map((x) => x)),
        sizes: List<Size>.from(json["sizes"].map((x) => x)),
        genders: List<Gender>.from(json["genders"].map((x) => x)),
        discount: json["discount"],
        isFavorite: json["is_favorite"],
      );

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    List<String>? images,
    ProductStore? store,
    ProductCategory? category,
    List<String>? colors,
    List<Size>? sizes,
    List<Gender>? genders,
    int? discount,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      store: store ?? this.store,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      genders: genders ?? this.genders,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ProductCategory {
  final int id;
  final String name;

  ProductCategory({
    required this.id,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json["id"],
        name: json["name"],
      );
}

class ProductStore {
  final int id;
  final String name;

  ProductStore({
    required this.id,
    required this.name,
  });

  factory ProductStore.fromJson(Map<String, dynamic> json) => ProductStore(
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
