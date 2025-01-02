import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:teqtop_team/utils/helpers.dart';

class InternetConnection {
  static Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    Helpers.printLog(
        description: "INTERNET_CONNECTION_IS_CONNECTED",
        message: "CONNECTIVITY_RESULT = $connectivityResult");

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }
}
