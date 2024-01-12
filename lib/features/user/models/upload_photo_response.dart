class UploadPhotoResponse {
  final bool success;
  final String message;
  final Image image;

  UploadPhotoResponse({
    required this.success,
    required this.message,
    required this.image,
  });

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) =>
      UploadPhotoResponse(
        success: json["success"],
        message: json["message"],
        image: Image.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "image": image.toJson(),
      };
}

class Image {
  final String fullUrlImage;
  final String partialUrlImage;
  final String imageName;

  Image({
    required this.fullUrlImage,
    required this.partialUrlImage,
    required this.imageName,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        fullUrlImage: json["full_url_image"],
        partialUrlImage: json["partial_url_image"],
        imageName: json["image_name"],
      );

  Map<String, dynamic> toJson() => {
        "full_url_image": fullUrlImage,
        "partial_url_image": partialUrlImage,
        "image_name": imageName,
      };
}
