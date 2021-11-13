import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/commons/utils.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class AccountBackend extends SimpleBackend {
  AccountBackend(BuildContext context) : super(context);

  late IUserService userService = getService<IUserService>();
  User? get currentUser => userService.currentUser;

  Future<void> signOut() async {
    bool done = await userService.signOut();
    if (done == false) {
      //TODO: Localize
      Utils.showCustomDialog(
        context: myContext,
        text: "Error while logging out",
      );
    } else {
      reloadApp();
    }
  }

  Future<void> signInGoogle() async {
    try {
      LoginResult result = await userService.signInGoogle();
      switch (result) {
        case LoginResult.DONE:
          reloadApp();
          break;
        case LoginResult.ALREADY_LOGGED_IN:
          //TODO: Localize
          await _show("Already Logged In");
          break;
        case LoginResult.ERROR:
          // TODO: Localize
          await _show("Error happened while logging in");
          break;
      }
    } catch (e) {
      // TODO: Localize
      await _show("Error occurred while logging in: $e");
    }
  }


  Future<void> signInGoogleEmail() async {
    //TODO: Localize
    await _show("عذراً, سيتم توفير هذه الخاصية قريباً");
  }
  Future<void> _show(String message) async {
    await Utils.showCustomDialog(
      context: myContext,
      text: message,
      title: Localization.ERROR,
    );
  }
}
