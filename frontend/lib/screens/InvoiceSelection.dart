import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class InvoiceSelection extends StatelessWidget {
  final Function setImage;
  final UserInfo user;
  final File image;

  InvoiceSelection({this.user, this.setImage, this.image});

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://balexpenses-bbaae.appspot.com/');

  StorageUploadTask _uploadTask;

  Future getImage() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setImage(_image);
  }

  void _startUpload() {
    var fileExtension = basename(image.path).split('.').last;

    String filePath =
        "invoices/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension";
    _storage.ref().child(filePath).putFile(image);
  }

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
            onPressed: _startUpload,
            child: Text("upload dummy"),
          )
        ],
      ),
    );
  }
}
