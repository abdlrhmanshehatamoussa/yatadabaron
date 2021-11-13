import 'package:flutter/material.dart';
import 'package:yatadabaron/commons/localization.dart';
import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/pages/account/backend.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';
import 'package:yatadabaron/widgets/user_avatar.dart';

class AccountView extends SimpleView<AccountBackend> {
  @override
  Widget build(BuildContext context) {
    AccountBackend backend = getBackend(context);

    Future<void> _handleSignOut() async {
      await backend.signOut();
    }

    Future<void> _handleSignInGoogle() async {
      await backend.signInGoogle();
    }

    Widget _loggedIn({
      required User user,
    }) {
      return Column(
        children: [
          //TODO: Localize
          ListTile(
            onTap: _handleSignOut,
            title: Text("تسجيل الخروج"),
            trailing: Icon(Icons.logout),
          )
        ],
      );
    }

    Widget _loggedOut() {
      return Column(
        //TODO: Localize
        children: [
          ListTile(
            onTap: _handleSignInGoogle,
            title: Text("تسجيل من خلال جوجل"),
            trailing: Icon(Icons.login),
          ),
        ],
      );
    }

    User? user = backend.currentUser;
    bool loggedIn = user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.ACCOUNT_MANAGEMENT),
      ),
      body: Center(
        child: Column(
          children: [
            UserAvatar(
              user: user,
            ),
            Expanded(
              child: loggedIn ? _loggedIn(user: user) : _loggedOut(),
            )
          ],
        ),
      ),
    );
  }

  @override
  AccountBackend buildBackend(ISimpleServiceProvider serviceProvider) {
    return AccountBackend(
      userService: serviceProvider.getService<IUserService>(),
    );
  }
}
