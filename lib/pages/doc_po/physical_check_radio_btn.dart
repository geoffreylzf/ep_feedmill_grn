import 'package:flutter/material.dart';

class PhysicalCheckRadioBtn extends StatefulWidget {
  final String title;
  final int defaultValue;
  final Function callback;

  PhysicalCheckRadioBtn({this.title, this.defaultValue, this.callback});

  @override
  _PhysicalCheckRadioBtnState createState() => _PhysicalCheckRadioBtnState();
}

class _PhysicalCheckRadioBtnState extends State<PhysicalCheckRadioBtn> {
  final pcStatus = ['N/A', 'Pass', 'Reject'];
  int v = 0;

  @override
  void initState() {
    super.initState();
    v = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i <= 2; i++)
                Row(
                  children: [
                    Radio(
                      value: i,
                      groupValue: v,
                      onChanged: (value) {
                        setState(() {
                          v = value;
                          widget.callback(value);
                        });
                      },
                    ),
                    Text(pcStatus[i]),
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }
}
