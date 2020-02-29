import 'package:ep_grn/modules/bluetooth.dart';
import 'package:ep_grn/notifiers/bluetooth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrintIndexPage extends StatefulWidget {
  final String text;

  PrintIndexPage(this.text);

  @override
  _PrintIndexPageState createState() => _PrintIndexPageState();
}

class _PrintIndexPageState extends State<PrintIndexPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BluetoothNotifier(BluetoothType.Printer),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("Print Preview")),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: BluetoothPanel(widget.text),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.text,
                          style: TextStyle(fontFamily: 'MonoSpace'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BluetoothPanel extends StatefulWidget {
  final String text;

  BluetoothPanel(this.text);

  @override
  _BluetoothPanelState createState() => _BluetoothPanelState();
}

class _BluetoothPanelState extends State<BluetoothPanel> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<BluetoothNotifier>(context);
    return Row(
      children: <Widget>[
        StreamBuilder<bool>(
            stream: bloc.isBluetoothEnabledStream,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.bluetooth),
                iconSize: 60,
                onPressed: snapshot.data ? () => showBluetoothDevices(context, bloc) : null,
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).accentColor,
              );
            }),
        StreamBuilder<bool>(
            stream: bloc.isBluetoothEnabledStream,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.refresh),
                iconSize: 60,
                onPressed: snapshot.data ? () => bloc.connectDevice() : null,
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).accentColor,
              );
            }),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<String>(
                  stream: bloc.statusStream,
                  builder: (context, snapshot) {
                    return Text(
                      "Status : ${snapshot.data.toString()}",
                      style: TextStyle(fontSize: 12),
                    );
                  }),
              StreamBuilder<String>(
                  stream: bloc.nameStream,
                  builder: (context, snapshot) {
                    return Text("Name : ${(snapshot.data ?? "")}", style: TextStyle(fontSize: 12));
                  }),
              StreamBuilder<String>(
                  stream: bloc.addressStream,
                  builder: (context, snapshot) {
                    return Text("Address : ${(snapshot.data ?? "")}",
                        style: TextStyle(fontSize: 12));
                  }),
            ],
          ),
        ),
        StreamBuilder<bool>(
            stream: bloc.isConnectedStream,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.print),
                iconSize: 60,
                onPressed: snapshot.data ? () => bloc.print(null, widget.text) : null,
                color: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).accentColor,
              );
            }),
      ],
    );
  }

  void showBluetoothDevices(BuildContext context, BluetoothNotifier bloc) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bloc.loadDevices();
          return AlertDialog(
            title: const Text("Bluetooth Devices"),
            content: Container(
              height: 300.0,
              width: 300.0,
              child: StreamBuilder<List<BluetoothDevice>>(
                  stream: bloc.devicesStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null || snapshot.data.isEmpty) {
                      return Center(
                          child: Text('Empty', style: Theme.of(context).textTheme.display1));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final devices = snapshot.data;
                        return Container(
                          color: (index % 2 == 0)
                              ? Theme.of(context).primaryColorLight
                              : Theme.of(context).scaffoldBackgroundColor,
                          child: ListTile(
                            onTap: () {
                              bloc.selectDevice(devices[index]);
                              Navigator.pop(context);
                            },
                            title: Row(
                              children: <Widget>[
                                Expanded(child: Text(devices[index].name)),
                                Expanded(child: Text(devices[index].address)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          );
        });
  }
}
