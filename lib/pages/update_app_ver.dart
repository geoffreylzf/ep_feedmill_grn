import 'package:ep_grn/notifiers/update_app_ver_notifier.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateAppVerPage extends StatefulWidget {
  @override
  _UpdateAppVerPageState createState() => _UpdateAppVerPageState();
}

class _UpdateAppVerPageState extends State<UpdateAppVerPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UpdateAppVerNotifier(),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(title: Text('Update App Version')),
          body: Stack(
            children: [
              _ErrorMessage(),
              Consumer<UpdateAppVerNotifier>(
                builder: (ctx, bloc, _) {
                  return Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      StreamBuilder<int>(
                          stream: bloc.verCodeStream,
                          initialData: 0,
                          builder: (context, snapshot) {
                            return Text("Version Code : ${snapshot.data}");
                          }),
                      StreamBuilder<String>(
                          stream: bloc.verNameStream,
                          initialData: "",
                          builder: (context, snapshot) {
                            return Text("Version Name : ${snapshot.data}");
                          }),
                      RaisedButton.icon(
                        onPressed: () => bloc.updateApp(),
                        icon: Icon(Icons.update),
                        label: Text("UPDATE APP VERSION"),
                      ),
                    ]),
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<UpdateAppVerNotifier>(context, listen: false).errMsgStream.listen((errMsg) {
      if (errMsg != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleAlertDialog(
              title: 'Error',
              message: errMsg,
            );
          },
        );
      }
    });
    return Container();
  }
}
