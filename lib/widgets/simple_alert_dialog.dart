import 'package:flutter/material.dart';

class SimpleAlertDialog extends StatelessWidget {
  final String title, message, btnText;

  SimpleAlertDialog({
    @required this.title,
    @required this.message,
    this.btnText: "CLOSE",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(btnText.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
