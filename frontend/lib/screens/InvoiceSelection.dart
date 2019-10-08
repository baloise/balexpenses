import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class InvoiceSelection extends StatelessWidget {
  final Function getImage;
  final UserInfo user;
  final File image;
  final Function startUpload;

  InvoiceSelection({this.user, this.image, this.startUpload, this.getImage});

  StorageUploadTask _uploadTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: getImage,
            child: Text("select image from gallery"),
          ),
          RaisedButton(
            onPressed: startUpload,
            child: Text("upload dummy"),
          )
        ],
      ),
    );
  }
}
