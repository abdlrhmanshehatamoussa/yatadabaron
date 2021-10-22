import 'package:yatadabaron/commons/custom-stream-controller.dart';
import 'package:yatadabaron/viewmodels/module.dart';

class AppSessionManager {
  AppSessionManager._();

  static AppSessionManager instance = AppSessionManager._();
  final StreamObject<AppSession> _streamObject = StreamObject();
  Stream<AppSession> get stream => _streamObject.stream;
  AppSession? currentSession;

  void update(AppSession session) {
    _streamObject.add(session);
    currentSession = session;
  }

  void updateTheme(ThemeDataWrapper wrapper) {
    AppSession session = AppSession(
      themeDataWrapper: wrapper,
    );
    update(session);
  }
}
