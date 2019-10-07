import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InvoiceSelection extends StatefulWidget {
  @override
  _InvoiceSelectionState createState() => _InvoiceSelectionState();
}

class _InvoiceSelectionState extends State<InvoiceSelection> {
  File _image;

  Future getImage() async {
    print("getImage");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: getImage,
            child: Text("select image from gallery"),
          )
        ],
      ),
    );
  }
}
