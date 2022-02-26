import 'package:yatadabaron/_modules/models.module.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/commons/api_helper.dart';
import 'package:yatadabaron/commons/constants.dart';
import 'package:yatadabaron/models/user.dart';
import 'package:yatadabaron/simple/_module.dart';

abstract class IUserService {
  Future<RegisterResult> registerGoogle();
  Future<LoginResult> signInGoogle();
  Future<bool> signOut();
  User? get currentUser;
}

class UserService extends IUserService implements ISimpleService {
  UserService({
    required this.sharedPreferences,
    required this.cloudHubAPIHelper,
  });

  final SharedPreferences sharedPreferences;
  final CloudHubAPIHelper cloudHubAPIHelper;
  final GoogleSignIn _google = GoogleSignIn(scopes: <String>['email']);

  @override
  User? get currentUser {
    String? userStr = sharedPreferences.getString(Constants.PREF_USER);
    if (userStr != null) {
      Map<String, dynamic> userJson = jsonDecode(userStr);
      return User.fromJson(userJson);
    }
    return null;
  }

  @override
  Future<RegisterResult> registerGoogle() async {
    try {
      await _google.signOut();
      GoogleSignInAccount? googleUser = await _google.signIn();
      if (googleUser == null) {
        return RegisterResult.ERROR;
      }
      GoogleSignInAuthentication auth = await googleUser.authentication;
      var registerResult = await cloudHubAPIHelper.registerGoogle(
        email: googleUser.email,
        token: auth.accessToken ?? "",
        imageUrl: googleUser.photoUrl,
        name: googleUser.displayName ?? "",
      );
      await _google.signOut();
      switch (registerResult.status) {
        case CloudHubRegisterStatus.SUCCESS:
          return RegisterResult.DONE;
        case CloudHubRegisterStatus.ALREADY_REGISTERED:
          return RegisterResult.ALREADY_REGISTERED;
        case CloudHubRegisterStatus.ERROR:
        default:
          return RegisterResult.ERROR;
      }
    } catch (e) {
      throw e;
    } finally {
      await _google.signOut();
    }
  }

  @override
  Future<LoginResult> signInGoogle() async {
    if (currentUser != null) {
      return LoginResult.ALREADY_LOGGED_IN;
    }
    await _google.signOut();
    GoogleSignInAccount? googleUser = await _google.signIn();
    if (googleUser == null) {
      return LoginResult.ERROR;
    }
    GoogleSignInAuthentication auth = await googleUser.authentication;
    CloudHubLoginResult loginPayload = await cloudHubAPIHelper.loginGoogle(
      email: googleUser.email,
      token: auth.accessToken ?? "",
    );
    switch (loginPayload.status) {
      case CloudHubLoginStatus.SUCCESS:
        User? user = User.fromCloudHubResponse(loginPayload.result!);
        if (user != null) {
          String userStr = jsonEncode(user.toJson());
          await sharedPreferences.setString(Constants.PREF_USER, userStr);
          return LoginResult.DONE;
        }
        return LoginResult.ERROR;
      case CloudHubLoginStatus.NOT_REGISTERED:
        return LoginResult.NOT_REGISTERED;
      case CloudHubLoginStatus.ERROR:
      default:
        return LoginResult.ERROR;
    }
  }

  @override
  Future<bool> signOut() async {
    await sharedPreferences.remove(Constants.PREF_USER);
    return true;
  }
}
