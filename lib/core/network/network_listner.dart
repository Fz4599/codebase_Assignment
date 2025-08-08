import 'package:flutter/material.dart';

import '../../config/router/injection.dart' as di;
import 'network_service.dart';

class NetworkListener extends StatelessWidget {
  final Widget child;

  const NetworkListener({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final networkService = di.sl<NetworkService>();

    return StreamBuilder<bool>(
      stream: networkService.onConnectionChange,
      builder: (context, snapshot) {
        final hasConnection = snapshot.data ?? true;
        return Stack(
          children: [
            child,
            if (!hasConnection)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'No Internet Connection',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
