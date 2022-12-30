import 'package:simply/simply.dart';

abstract class IVersionInfoService extends SimpleService {
  String getVersionName();
  String getBuildId();
}
