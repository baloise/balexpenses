import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InvoiceSelection extends StatelessWidget {
  final UserInfo user;

  InvoiceSelection({this.user});

  File _image;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://balexpenses-bbaae.appspot.com/');

  StorageUploadTask _uploadTask;

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _startUpload() {
    String filePath = 'invoices/${user.uid}/nase.jpg';
    _storage.ref().child(filePath).putFile(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
//          Container(
//            width: 150,
//            height: 100,
//            decoration:
//                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
//            child: this._image != null
//                ? Image.file(
//                    _image,
//                    fit: BoxFit.cover,
//                    width: double.infinity,
//                  )
//                : Text(
//                    'No Image Selected',
//                    textAlign: TextAlign.center,
//                  ),
//          ),
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
