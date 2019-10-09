import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final UserInfo user;
  final String result;
  final Function getResult;

  const ResultScreen({this.user, this.result, this.getResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(user != null ? user.uid : ''),
          Text(result != null ? result : ''),
          RaisedButton(
            child: Text('get Result'),
            onPressed: getResult,
          )
        ],
      ),
    );
  }
}
