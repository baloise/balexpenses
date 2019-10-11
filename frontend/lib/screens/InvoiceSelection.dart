import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InvoiceSelection extends StatelessWidget {
  final Function getImage;
  final UserInfo user;
  final File image;

  InvoiceSelection({this.user, this.image, this.getImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: getImage,
            child: Text("select image from gallery"),
          ),
        ],
      ),
    );
  }
}
