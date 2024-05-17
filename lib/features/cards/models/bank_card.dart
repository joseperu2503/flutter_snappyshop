class BankCard {
  final String cardNumber;
  final String cardHolderName;
  final String expired;
  final String ccv;
  final int? paymenthMethod;

  BankCard({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expired,
    required this.ccv,
    required this.paymenthMethod,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) => BankCard(
        cardNumber: json["cardNumber"],
        cardHolderName: json["cardHolderName"],
        expired: json["expired"],
        ccv: json["ccv"],
        paymenthMethod: json["paymenthMethod"],
      );

  Map<String, dynamic> toJson() => {
        "cardNumber": cardNumber,
        "cardHolderName": cardHolderName,
        "expired": expired,
        "ccv": ccv,
        "paymenthMethod": paymenthMethod,
      };
}
