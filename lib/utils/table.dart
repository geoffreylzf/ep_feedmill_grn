import 'package:flutter/material.dart';

class TableHeaderCell extends StatelessWidget {
  final String text;

  TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[500], fontSize: 8),
      ),
    );
  }
}

class TableDetailCell extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  TableDetailCell(
      this.text, {
        this.textAlign = TextAlign.center,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}