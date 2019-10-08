import 'dart:io';

import 'package:balexpenses/screens/InvoiceSelection.dart';
import 'package:flutter/material.dart';

class Invoices extends StatefulWidget {
  final user;

  const Invoices({this.user});

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  File _image;

  void _setImage(File image) {
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
      InvoiceSelection(user: widget.user, setImage: _setImage, image: _image),
    ]);
  }
}
