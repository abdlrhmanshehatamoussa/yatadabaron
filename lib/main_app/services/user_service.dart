import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/commons/constants.dart';
import 'package:yatadabaron/models/user.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class UserService extends IUserService implements ISimpleService {
  UserService({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;
  final _google = GoogleSignIn(scopes: <String>['email']);

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
    //TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<LoginResult> signInGoogle() async {
    if (currentUser == null) {
      try {
        await _google.signOut();
        GoogleSignInAccount? googleUser = await _google.signIn();
        if (googleUser != null) {
          //TODO: Implement
          User user = User(
            globalId: "1231",
            displayName: "Abdelrahman Shehata",
            imageURL: googleUser.photoUrl ?? "",
            email: "abdlrhmanshehata@gmail.com",
            token: "21asd557asd7565a4sd",
          );
          String userStr = jsonEncode(user.toJson());
          await sharedPreferences.setString(Constants.PREF_USER, userStr);
          return LoginResult.DONE;
        } else {
          return LoginResult.ERROR;
        }
      } catch (e) {
        return LoginResult.ERROR;
      }
    } else {
      return LoginResult.ALREADY_LOGGED_IN;
    }
  }

  @override
  Future<bool> signOut() async {
    await sharedPreferences.remove(Constants.PREF_USER);
    return true;
  }
}
