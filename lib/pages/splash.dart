import 'package:ep_grn/notifiers/local_notifier.dart';
import 'package:ep_grn/notifiers/user_repository_notifier.dart';
import 'package:ep_grn/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _isShowRefreshBtnSubject = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initUserRepository();
    });
  }


  @override
  void dispose() {
    _isShowRefreshBtnSubject.close();
    super.dispose();
  }

  void initUserRepository() async {
    final msg = await Provider.of<UserRepositoryNotifier>(context, listen: false).init();
    if (msg != null) {
      _isShowRefreshBtnSubject.add(true);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleAlertDialog(
            title: 'Error',
            message: msg,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Theme.of(context).primaryColor),
          Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
              size: 50.0,
            ),
          ),
          StreamBuilder<bool>(
              stream: _isShowRefreshBtnSubject.stream,
              initialData: false,
              builder: (context, snapshot) {
                if(snapshot.data){
                  return Align(
                    alignment: Alignment(0, 0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          child: Icon(Icons.refresh),
                          tooltip: 'Refresh',
                          onPressed: () {
                            initUserRepository();
                          },
                        ),
                        LocalCheckBox(),
                      ],
                    ),
                  );
                }
                return Container();
              }
          ),

        ],
      ),
    );
  }
}


class LocalCheckBox extends StatefulWidget {
  @override
  _LocalCheckBoxState createState() => _LocalCheckBoxState();
}

class _LocalCheckBoxState extends State<LocalCheckBox> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LocalNotifier>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<bool>(
            stream: bloc.localCheckedStream,
            initialData: false,
            builder: (context, snapshot) {
              return Checkbox(
                value: snapshot.data,
                onChanged: (bool b) {
                  bloc.setLocalChecked(b);
                },
              );
            }),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            "Local (Connect Office Wi-Fi)",
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}
