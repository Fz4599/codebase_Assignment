import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Stream<bool> get onConnectionChange {
    return _connectivity.onConnectivityChanged.map(
          (result) => result != ConnectivityResult.none,
    );
  }
}
