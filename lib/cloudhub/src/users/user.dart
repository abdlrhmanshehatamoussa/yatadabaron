class CloudHubUser {
  final String globalId;
  final String displayName;
  final String email;
  final String imageURL;
  final String token;
  final String loginType;
  final int tokenExpiresIn;

  CloudHubUser({
    required this.globalId,
    required this.displayName,
    required this.imageURL,
    required this.email,
    required this.token,
    required this.loginType,
    required this.tokenExpiresIn,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["displayName"] = displayName;
    map["email"] = email;
    map["token"] = token;
    map["globalId"] = globalId;
    map["imageURL"] = imageURL;
    map["tokenExpiresIn"] = tokenExpiresIn;
    map["loginType"] = loginType;
    return map;
  }

  static CloudHubUser? fromJson(Map<String, dynamic> userJson) {
    return CloudHubUser(
      displayName: userJson["displayName"],
      email: userJson["email"],
      globalId: userJson["globalId"],
      imageURL: userJson["imageURL"],
      token: userJson["token"],
      loginType: userJson["loginType"],
      tokenExpiresIn: userJson["tokenExpiresIn"],
    );
  }

  static CloudHubUser? fromCloudHubResponse(Map<String, dynamic> userMap) {
    return CloudHubUser(
      globalId: userMap["global_id"],
      token: userMap["user_token"],
      displayName: userMap["name"],
      imageURL: userMap["image_url"],
      email: userMap["email"],
      loginType: userMap["login_type"],
      tokenExpiresIn: userMap["user_token_expires_in"],
    );
  }
}
