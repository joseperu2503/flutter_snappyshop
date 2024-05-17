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

class Order {
  final int id;
  final OrderStatus user;
  final double totalAmount;
  final int shippingFee;
  final String cardNumber;
  final OrderStatus orderStatus;
  final Address address;
  final OrderStatus paymentMethod;
  final int items;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.user,
    required this.totalAmount,
    required this.shippingFee,
    required this.cardNumber,
    required this.orderStatus,
    required this.address,
    required this.paymentMethod,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        user: OrderStatus.fromJson(json["user"]),
        totalAmount: json["total_amount"]?.toDouble(),
        shippingFee: json["shipping_fee"],
        cardNumber: json["card_number"],
        orderStatus: OrderStatus.fromJson(json["order_status"]),
        address: Address.fromJson(json["address"]),
        paymentMethod: OrderStatus.fromJson(json["payment_method"]),
        items: json["items"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "total_amount": totalAmount,
        "shipping_fee": shippingFee,
        "card_number": cardNumber,
        "order_status": orderStatus.toJson(),
        "address": address.toJson(),
        "payment_method": paymentMethod.toJson(),
        "items": items,
        "created_at": createdAt.toIso8601String(),
      };
}

class Address {
  final int id;
  final OrderStatus user;
  final String address;
  final String detail;
  final String phone;
  final String recipientName;
  final String references;
  final double latitude;
  final double longitude;
  final bool primary;
  final DateTime createdAt;

  Address({
    required this.id,
    required this.user,
    required this.address,
    required this.detail,
    required this.phone,
    required this.recipientName,
    required this.references,
    required this.latitude,
    required this.longitude,
    required this.primary,
    required this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        user: OrderStatus.fromJson(json["user"]),
        address: json["address"],
        detail: json["detail"],
        phone: json["phone"],
        recipientName: json["recipient_name"],
        references: json["references"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        primary: json["primary"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "address": address,
        "detail": detail,
        "phone": phone,
        "recipient_name": recipientName,
        "references": references,
        "latitude": latitude,
        "longitude": longitude,
        "primary": primary,
        "created_at": createdAt.toIso8601String(),
      };
}

class OrderStatus {
  final int id;
  final String name;

  OrderStatus({
    required this.id,
    required this.name,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
