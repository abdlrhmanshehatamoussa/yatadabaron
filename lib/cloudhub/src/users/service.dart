import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import '../constans.dart';
import '../sdk.dart';
import 'dtos.dart';
import 'user.dart';

class CloudHubUsers {
  static CloudHubUsers? _instance;
  static CloudHubUsers get instance =>
      _instance ?? new CloudHubUsers._(CloudHubSDK.instance);

  //Class begins here
  CloudHubUsers._(this.sdk);
  final CloudHubSDK sdk;
  final GoogleSignIn _google = GoogleSignIn(scopes: <String>['email']);

  CloudHubUser? get currentUser {
    String? userStr =
        sdk.preferences.getString(CloudHubConstants.SHARED_PREF_KEY_USERS);
    if (userStr != null) {
      Map<String, dynamic> userJson = jsonDecode(userStr);
      return CloudHubUser.fromJson(userJson);
    }
    return null;
  }

  Future<CloudHubRegisterStatus> registerGoogle() async {
    try {
      await _google.signOut();
      GoogleSignInAccount? googleUser = await _google.signIn();
      if (googleUser == null) {
        return CloudHubRegisterStatus.ERROR;
      }
      GoogleSignInAuthentication auth = await googleUser.authentication;
      var registerResult = await register(
        email: googleUser.email,
        token: auth.accessToken ?? "",
        imageUrl: googleUser.photoUrl,
        name: googleUser.displayName ?? "",
        loginType: CloudHubConstants.LOGINTYPE_GOOGLE,
      );
      await _google.signOut();
      return registerResult.status;
    } catch (e) {
      throw e;
    } finally {
      await _google.signOut();
    }
  }

  Future<CloudHubLoginStatus> signInGoogle() async {
    if (currentUser != null) {
      return CloudHubLoginStatus.ALREADY_LOGGED_IN;
    }
    await _google.signOut();
    GoogleSignInAccount? googleUser = await _google.signIn();
    if (googleUser == null) {
      return CloudHubLoginStatus.ERROR;
    }
    GoogleSignInAuthentication auth = await googleUser.authentication;
    CloudHubLoginResult loginPayload = await login(
      email: googleUser.email,
      token: auth.accessToken ?? "",
      loginType: CloudHubConstants.LOGINTYPE_GOOGLE,
    );
    CloudHubUser? user =
        CloudHubUser.fromCloudHubResponse(loginPayload.result!);
    if (user != null) {
      String userStr = jsonEncode(user.toJson());
      await sdk.preferences
          .setString(CloudHubConstants.SHARED_PREF_KEY_USERS, userStr);
      return CloudHubLoginStatus.SUCCESS;
    }
    return loginPayload.status;
  }

  Future<bool> signOut() async {
    await sdk.preferences.remove(CloudHubConstants.SHARED_PREF_KEY_USERS);
    return true;
  }

  Future<CloudHubLoginResult> login({
    required String email,
    required String token,
    required int loginType,
  }) async {
    //TODO: Validate input parameters
    dynamic payload = {
      "email": email,
      "password": token,
      "login_type": loginType,
    };
    String payloadStr = jsonEncode(payload);
    Response response = await sdk.httpPOST(
      endpoint: CloudHubConstants.ENDPOINT_USER_LOGIN,
      payload: payloadStr,
    );
    switch (response.statusCode) {
      case 200:
        return CloudHubLoginResult(
          CloudHubLoginStatus.SUCCESS,
          jsonDecode(response.body),
        );
      case 495:
        return CloudHubLoginResult(
          CloudHubLoginStatus.NOT_REGISTERED,
          null,
        );
      default:
        return CloudHubLoginResult(
          CloudHubLoginStatus.ERROR,
          null,
        );
    }
  }

  Future<CloudHubRegisterResult> register({
    required String email,
    required String token,
    required String name,
    required String? imageUrl,
    required int loginType,
  }) async {
    //TODO: Validate input parameters
    dynamic payload = {
      "email": email,
      "password": token,
      "login_type": loginType,
      "image_url": imageUrl,
      "name": name,
    };
    String payloadStr = jsonEncode(payload);
    Response response = await sdk.httpPOST(
      endpoint: CloudHubConstants.ENDPOINT_USER,
      payload: payloadStr,
    );
    switch (response.statusCode) {
      case 200:
        return CloudHubRegisterResult(
          CloudHubRegisterStatus.SUCCESS,
          jsonDecode(response.body),
        );
      case 494:
        return CloudHubRegisterResult(
          CloudHubRegisterStatus.ALREADY_REGISTERED,
          null,
        );
      default:
        return CloudHubRegisterResult(
          CloudHubRegisterStatus.ERROR,
          null,
        );
    }
  }
}
