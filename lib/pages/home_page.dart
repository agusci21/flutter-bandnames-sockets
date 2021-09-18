import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Pink Floid', votes: 1),
    Band(
      id: '3',
      name: 'Queen',
      votes: 5,
    ),
    Band(id: '4', name: 'Bon Jovi', votes: 6),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          ' BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  ListTile _bandTile(Band band) => ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {
          // ignore: avoid_print
          print(band.name);
        },
      );
}
