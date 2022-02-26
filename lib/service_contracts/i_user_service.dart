import 'package:yatadabaron/_modules/models.module.dart';

abstract class IUserService {
  Future<RegisterResult> registerGoogle();
  Future<LoginResult> signInGoogle();
  Future<bool> signOut();
  User? get currentUser;
}
