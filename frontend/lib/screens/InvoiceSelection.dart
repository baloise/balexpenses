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
          Container(
            width: 150,
            height: 100,
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: this._image != null
                ? Image.file(
                    _image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Text(
                    'No Image Selected',
                    textAlign: TextAlign.center,
                  ),
          ),
          RaisedButton(
            onPressed: getImage,
            child: Text("select image from gallery"),
          )
        ],
      ),
    );
  }
}
