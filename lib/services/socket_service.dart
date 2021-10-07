import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  OnLine,
  OffLine,
  Connecting,
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.OnLine;

  get serverStatus => this._serverStatus;

  SocketService(){
    this.initConfig();
  }

  void initConfig(){

    IO.Socket socket = IO.io('http://192.168.54.177:3000', {
      'transports' : ['websocket'],
      'autoConnect': true,
    });
    
    socket.on('connect', (_) {
      this._serverStatus = ServerStatus.OnLine;
      notifyListeners();
    });

    socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();
    });

  }

}