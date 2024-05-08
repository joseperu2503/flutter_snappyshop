class BankCard {
  final String cardNumber;
  final String cardHolderName;
  final String expired;
  final String ccv;

  BankCard({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expired,
    required this.ccv,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) => BankCard(
        cardNumber: json["cardNumber"],
        cardHolderName: json["cardHolderName"],
        expired: json["expired"],
        ccv: json["ccv"],
      );

  Map<String, dynamic> toJson() => {
        "cardNumber": cardNumber,
        "cardHolderName": cardHolderName,
        "expired": expired,
        "ccv": ccv,
      };
}
