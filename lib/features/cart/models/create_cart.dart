class CreateCart {
  final int id;
  final int quantity;

  CreateCart({
    required this.id,
    required this.quantity,
  });

  factory CreateCart.fromJson(Map<String, dynamic> json) => CreateCart(
        id: json["id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
      };
}
