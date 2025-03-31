import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus { online, offline }

class NetworkStatusNotifier extends StateNotifier<NetworkStatus> {
  StreamSubscription? _subscription;

  NetworkStatusNotifier() : super(NetworkStatus.offline) {
    _monitorNetworkStatus();
  }

  void _monitorNetworkStatus() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        state = NetworkStatus.offline;
      } else {
        state = NetworkStatus.online;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final networkStatusProvider = StateNotifierProvider<NetworkStatusNotifier, NetworkStatus>((ref) {
  return NetworkStatusNotifier();
});
