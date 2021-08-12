import 'package:ep_grn/notifiers/local_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: ListView(
        children: [
          LocalTitle(),
        ],
      ),
    );
  }
}

class LocalTitle extends StatefulWidget {
  @override
  _LocalTitleState createState() => _LocalTitleState();
}

class _LocalTitleState extends State<LocalTitle> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LocalNotifier>(context);
    return ListTile(
      dense: true,
      title: Text("Local Network"),
      subtitle: Text("Tick this when using EP Group Wi-Fi"),
      trailing: StreamBuilder<bool>(
          stream: bloc.localCheckedStream,
          initialData: false,
          builder: (context, snapshot) {
            return Switch(
              value: snapshot.data,
              onChanged: (bool b) {
                bloc.setLocalChecked(b);
              },
            );
          }),
    );
  }
}
