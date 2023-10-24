import 'dart:io';

import 'package:bands_name_app/config/services/socket_service.dart';
import 'package:bands_name_app/datasource/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketProvider = Provider.of<SocketService>(context, listen: false);
    socketProvider.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketService>(context, listen: false);
    socketProvider.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketService>(context);
    final ServerStatus serverStatus = socketProvider.serverStatus;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: serverStatus == ServerStatus.online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(child: _showGraph()),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) {
                final band = bands[index];
                return _bandListTile(band);
              },
            ),
          ),
        ],
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
        builder: (_) => AlertDialog(
            title: const Text('New band name'),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              MaterialButton(
                child: const Text('Add'),
                onPressed: () => addBandToList(textEditingController.text),
              ),
            ]),
      );
    } else if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
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
        ),
      );
    }
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.emit('add-band', {
        "name": name,
      });
    }
    Navigator.of(context).pop();
  }

  Widget _bandListTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => socketService.emit('delete-band', {
        "id": band.id,
      }),
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
        onTap: () => socketService.socket.emit('vote-band', {
          "id": band.id,
        }),
      ),
    );
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        chartType: ChartType.ring,
        chartValuesOptions:
            const ChartValuesOptions(showChartValuesInPercentage: true),
        dataMap: dataMap,
      ),
    );
  }
}
