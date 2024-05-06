class MyOrdersResponse {
  final List<Order> results;
  final Info info;

  MyOrdersResponse({
    required this.results,
    required this.info,
  });

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) =>
      MyOrdersResponse(
        results:
            List<Order>.from(json["results"].map((x) => Order.fromJson(x))),
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
}

class Order {
  final int id;
  final User user;
  final int totalAmount;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.user,
    required this.totalAmount,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        user: User.fromJson(json["user"]),
        totalAmount: json["total_amount"],
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
