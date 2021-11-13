import 'package:yatadabaron/models/module.dart';
import 'package:yatadabaron/services/module.dart';
import 'package:yatadabaron/simple/module.dart';

class AccountBackend implements ISimpleBackend {
  AccountBackend({
    required this.userService,
  });

  final IUserService userService;

  User? get currentUser => userService.currentUser;

  Future<bool> signOut() async {
    bool done = await userService.signOut();
    return done;
  }

  Future<void> signInGoogle() async {
    await userService.signInGoogle();
  }
}
