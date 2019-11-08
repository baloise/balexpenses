import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InvoiceSelection extends StatelessWidget {
  final Function getImage;
  final UserInfo user;
  final File image;
  final Function startUpload;
  final Function clear;
  final Function cropImage;

  InvoiceSelection(
      {this.user,
      this.image,
      this.startUpload,
      this.getImage,
      this.clear,
      this.cropImage});

  StorageUploadTask _uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  size: 30,
                ),
                onPressed: () => getImage(ImageSource.camera),
                color: Colors.blue,
              ),
              IconButton(
                icon: Icon(
                  Icons.photo_library,
                  size: 30,
                ),
                onPressed: () => getImage(ImageSource.gallery),
                color: Colors.pink,
              ),
            ],
          ),
        ),
        body: Container()
        /*ListView(
        children: <Widget>[
          if (image != null) ...[
            Container(padding: EdgeInsets.all(32), child: Image.file(image)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.black,
                  child: Icon(Icons.crop),
                  onPressed: cropImage,
                ),
                FlatButton(
                  color: Colors.black,
                  child: Icon(Icons.refresh),
                  onPressed: clear,
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(32),
                child: MaterialButton(
                  onPressed: startUpload,
                  child: Text("upload dummy"),
                ))
          ]
        ],
      ),*/
        );
  }
}

/*
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
*/
