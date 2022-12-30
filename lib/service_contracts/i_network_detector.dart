import 'package:simply/simply.dart';

abstract class INetworkDetectorService extends SimpleService {
  Future<bool> isOnline();
}
