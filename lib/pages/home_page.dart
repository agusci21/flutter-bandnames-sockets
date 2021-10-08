import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band_model.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();

    
  }

  _handleActiveBands(dynamic payload){
    this.bands = (payload as List)
      .map((band) => Band.fromMap(band))
      .toList(); 

      setState(() {});
  }

  @override
  void dispose() {

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  List<Band> bands = [];


  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle( color: Colors.black87 ) ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:socketService.serverStatus == ServerStatus.OnLine 
              ? Icon(Icons.check_circle,color: Colors.blue,)
              : Icon(Icons.offline_bolt,color: Colors.red,)
             
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context, i ) => _bandTile( bands[i] )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        elevation: 1,
        onPressed: addNewBand
      ),
   );
  }

  Widget _bandTile( Band band ) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.emit('delete-band', {'id' : band.id}),
      background: Container(
        padding: EdgeInsets.only( left: 8.0 ),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle( color: Colors.white) ),
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name.substring(0,2) ),
          backgroundColor: Colors.blue[100],
        ),
        title: Text( band.name ),
        trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20) ),
        onTap: () => socketService.socket.emit('vote-band', {'id':band.id}),
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();
    
    if ( Platform.isAndroid ) {
      // Android
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList( textController.text )
              )
            ],
          )
        ,
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (_) => CupertinoAlertDialog(
          title: Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList( textController.text )
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context)
            )
          ],
        )
    );
  }  

  void addBandToList( String name ) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    if ( name.length > 1 ) {
      socketService.emit('add-band', { 'name': name });
    }


    Navigator.pop(context);

  }

}