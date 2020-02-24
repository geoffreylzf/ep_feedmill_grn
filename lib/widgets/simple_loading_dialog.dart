import 'package:flutter/material.dart';

class SimpleLoadingDialog extends StatefulWidget {
  final bool isShow;

  SimpleLoadingDialog(this.isShow);

  @override
  _SimpleLoadingDialogState createState() => _SimpleLoadingDialogState();
}

class _SimpleLoadingDialogState extends State<SimpleLoadingDialog> {
  @override
  Widget build(BuildContext context) {
    if (widget.isShow) {
      return Positioned.fill(
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child: Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
