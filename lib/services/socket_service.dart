import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  OnLine,
  OffLine,
  Connecting,
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;

  SocketService(){
    this.initConfig();
  }

  void initConfig(){

    IO.Socket socket = IO.io('http://192.168.54.177:3000', {
      'transports' : ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) {
    print('connect');
   });
   socket.onDisconnect((_) => print('disconnect'));

  }

}