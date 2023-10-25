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
  // https://flutter-socket-server-d80c2b2474b1.herokuapp.com/
  //! link necessario para o celular acessar o localhost 'http://10.0.2.2:3000'
  void initConfig() {
    _socket = IO.io("https://balbasa.onrender.com", {
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
