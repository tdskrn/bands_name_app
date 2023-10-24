import 'package:bands_name_app/config/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Server Status: ${socketService.serverStatus}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.emit('flutter-message',
              {"name": "Flutter", "msg": "Msg enviada do Flutter"});
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
