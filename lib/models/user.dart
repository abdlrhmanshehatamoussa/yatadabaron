class User {
  final String globalId;
  final String displayName;
  final String email;
  final String imageURL;
  final String token;

  User({
    required this.globalId,
    required this.displayName,
    required this.imageURL,
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["displayName"] = displayName;
    map["email"] = email;
    map["token"] = token;
    map["globalId"] = globalId;
    map["imageURL"] = imageURL;
    return map;
  }

  static User? fromJson(Map<String, dynamic> userJson) {
    return User(
      displayName: userJson["displayName"],
      email: userJson["email"],
      globalId: userJson["globalId"],
      imageURL: userJson["imageURL"],
      token: userJson["token"],
    );
  }
}

enum LoginResult { DONE, ALREADY_LOGGED_IN,ERROR }

enum RegisterResult { DONE, ALREADY_REGISTERED }
