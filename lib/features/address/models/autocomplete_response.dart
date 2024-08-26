class AddressResult {
  final String placeId;
  final StructuredFormatting structuredFormatting;

  AddressResult({
    required this.placeId,
    required this.structuredFormatting,
  });

  factory AddressResult.fromJson(Map<String, dynamic> json) => AddressResult(
        placeId: json["place_id"],
        structuredFormatting:
            StructuredFormatting.fromJson(json["structured_formatting"]),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "structured_formatting": structuredFormatting.toJson(),
      };
}

class StructuredFormatting {
  final String mainText;
  final String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "secondary_text": secondaryText,
      };
}
