class SendVerifyCodeResponse {
  final bool success;
  final String message;
  final Data data;

  SendVerifyCodeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SendVerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      SendVerifyCodeResponse(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final String uuid;
  final DateTime expirationDate;

  Data({
    required this.uuid,
    required this.expirationDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        uuid: json["uuid"],
        expirationDate: DateTime.parse(json["expiration_date"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "expiration_date": expirationDate.toIso8601String(),
      };
}
