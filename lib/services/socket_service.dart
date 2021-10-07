import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  OnLine,
  OffLine,
  Connecting,
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.OnLine;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  SocketService(){
    this.initConfig();
  }

  void initConfig(){

     _socket = IO.io('http://192.168.54.177:3000', {
      'transports' : ['websocket'],
      'autoConnect': true,
    });
    
    _socket.on('connect', (_) {
      this._serverStatus = ServerStatus.OnLine;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();
    });

    /*socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje: ');
      print('nombre: ' + payload['nombre']);
      print('mensaje: ' + payload['mensaje']);
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No Hay');
    });*/

  }

}