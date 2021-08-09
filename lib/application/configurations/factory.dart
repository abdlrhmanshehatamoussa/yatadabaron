import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'configurations-service.dart';
import 'interface.dart';

class ConfigurationServiceFactory {
  static Future<IConfigurationService> create() async {
    await dotenv.load(fileName: 'assets/.env');
    return new ConfigurationService();
  }
}
