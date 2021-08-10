import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';

import 'configurations-service.dart';
import 'interface.dart';

class ConfigurationServiceFactory {
  static Future<IConfigurationService> create() async {
    await dotenv.load(fileName: 'assets/.env');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return new ConfigurationService(packageInfo);
  }
}
