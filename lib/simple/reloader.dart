import 'interfaces.dart';

class SimpleAppReloader implements ISimpleAppReloader {
  final void Function(String) onReload;

  SimpleAppReloader({
    required this.onReload,
  });

  @override
  void reload(String reloadMessage) {
    this.onReload(reloadMessage);
  }
}
