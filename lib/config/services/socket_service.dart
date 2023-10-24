import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;
  ServerStatus get serverStatus => _serverStatus;
  Function get emit => _socket.emit;
  Function get off => _socket.off;
  IO.Socket get socket => _socket;

  SocketService() {
    initConfig();
  }

  void initConfig() {
    _socket = IO.io('http://10.0.2.2:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      debugPrint('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      debugPrint('disconnect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.emit(
      'message-flutter',
    );
  }
}
