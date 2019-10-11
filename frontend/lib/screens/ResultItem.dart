import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {

  final String content;

  ResultItem(this.content);

  @override
  Widget build(BuildContext context) {
    return Text("XX $content");
  }
}
