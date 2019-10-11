import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {

  final String label;
  final String value;

  ResultItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title: Text(
            value,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        subtitle: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
