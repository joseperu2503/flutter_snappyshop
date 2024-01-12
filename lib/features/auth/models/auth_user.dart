class AuthUser {
  final int id;
  final String name;
  final String email;
  final String? profilePhoto;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePhoto,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        profilePhoto: json["profile_photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profile_photo": profilePhoto,
      };
}
