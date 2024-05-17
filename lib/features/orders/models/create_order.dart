class CreateOrder {
  final int id;
  final int quantity;

  CreateOrder({
    required this.id,
    required this.quantity,
  });

  factory CreateOrder.fromJson(Map<String, dynamic> json) => CreateOrder(
        id: json["id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
      };
}
