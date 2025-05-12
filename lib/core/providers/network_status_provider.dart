import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkStatusProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    // Преобразуем Stream<List<ConnectivityResult>> в Stream<ConnectivityResult>
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return ConnectivityResult.none;
    }
  });
});
