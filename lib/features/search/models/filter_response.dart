class FilterResponse {
  final List<GenderFilter> genders;
  final List<BrandFilter> brands;
  final List<CategoryFilter> categories;
  final List<SizeFilter> sizes;

  FilterResponse({
    required this.genders,
    required this.brands,
    required this.categories,
    required this.sizes,
  });

  factory FilterResponse.fromJson(Map<String, dynamic> json) => FilterResponse(
        genders: List<GenderFilter>.from(
            json["genders"].map((x) => GenderFilter.fromJson(x))),
        brands: List<BrandFilter>.from(
            json["brands"].map((x) => BrandFilter.fromJson(x))),
        categories: List<CategoryFilter>.from(
            json["categories"].map((x) => CategoryFilter.fromJson(x))),
        sizes: List<SizeFilter>.from(
            json["sizes"].map((x) => SizeFilter.fromJson(x))),
      );
}

class BrandFilter {
  final int? id;
  final String name;

  BrandFilter({
    required this.id,
    required this.name,
  });

  factory BrandFilter.fromJson(Map<String, dynamic> json) => BrandFilter(
        id: json["id"],
        name: json["name"],
      );
}

class CategoryFilter {
  final int? id;
  final String name;

  CategoryFilter({
    required this.id,
    required this.name,
  });

  factory CategoryFilter.fromJson(Map<String, dynamic> json) => CategoryFilter(
        id: json["id"],
        name: json["name"],
      );
}

class GenderFilter {
  final int? id;
  final String name;

  GenderFilter({
    required this.id,
    required this.name,
  });

  factory GenderFilter.fromJson(Map<String, dynamic> json) => GenderFilter(
        id: json["id"],
        name: json["name"],
      );
}

class SizeFilter {
  final int? id;
  final String name;

  SizeFilter({
    required this.id,
    required this.name,
  });

  factory SizeFilter.fromJson(Map<String, dynamic> json) => SizeFilter(
        id: json["id"],
        name: json["name"],
      );
}
