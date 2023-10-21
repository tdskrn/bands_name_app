import 'dart:io';

import 'package:bands_name_app/datasource/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'Bon Jovi', votes: 10),
    Band(id: '2', name: 'Queen', votes: 8),
    Band(id: '3', name: 'Metallica', votes: 3),
    Band(id: '4', name: 'Sllipknot', votes: 6),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) {
          final band = bands[index];
          return _bandListTile(band);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  addNewBand() {
    final TextEditingController textEditingController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('New band name'),
              content: TextField(
                controller: textEditingController,
              ),
              actions: [
                MaterialButton(
                  child: const Text('Add'),
                  onPressed: () => addBandToList(textEditingController.text),
                ),
              ]);
        },
      );
    } else if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New Band name'),
            content: CupertinoTextField(controller: textEditingController),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () => addBandToList(textEditingController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('dismiss'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));

      setState(() {});
    }
    Navigator.of(context).pop();
  }
}

Widget _bandListTile(Band band) {
  return Dismissible(
    key: Key(band.id),
    direction: DismissDirection.startToEnd,
    onDismissed: (direction) {
      debugPrint('direction: $direction');
      debugPrint('id: ${band.id}');
      // TODO deletar no server
    },
    background: Container(
      padding: const EdgeInsets.only(left: 8.0),
      color: Colors.red,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(band.name.substring(0, 2)),
      ),
      title: Text(band.name),
      trailing: Text(
        '${band.votes}',
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {
        debugPrint(band.name);
      },
    ),
  );
}
