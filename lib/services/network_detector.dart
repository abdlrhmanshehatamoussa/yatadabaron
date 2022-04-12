import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class NetworkDetectorService
    implements INetworkDetectorService, ISimpleService {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> isOnline() async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          return true;
        case ConnectivityResult.bluetooth:
        case ConnectivityResult.none:
        default:
          return false;
      }
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
