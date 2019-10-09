import 'dart:io';

import 'package:balexpenses/screens/InvoiceSelection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:balexpenses/models/Invoice.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


class Invoices extends StatefulWidget {
  final user;

  const Invoices({this.user});

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  File _image;
  String fileId;
  double _guiSum;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://balexpenses-bbaae.appspot.com/');

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        width: 150,
        height: 100,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: _image != null
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
      Text("Ermittelte Summe: ${_guiSum.toString()} EUR"),
      InvoiceSelection(
          user: widget.user,
          image: _image,
          startUpload: _startUpload,
          getImage: _getImage),
      RaisedButton(
        onPressed: scanSumAndDisplay,
        child: Text("OCR"),
      ),
      RaisedButton(
        child: Text('abc'),
        onPressed: saveOcrData,
      )
    ]);
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _image = image;
    });
  }

  void _startUpload() {
    var fileExtension = basename(_image.path).split('.').last;

    String filePath = "invoices/${widget.user.uid}/$fileId.$fileExtension";
    _storage.ref().child(filePath).putFile(_image);
  }

  Future<Invoice> scanInvoice() async {
    double sum = 0;
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    Rect bb;
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.startsWith("S u")) {
          bb = line.boundingBox;
        }
        if (bb != null && !line.text.startsWith("S u") && (line.boundingBox.bottomLeft.dy - bb.bottomLeft.dy).abs() < 4.0) {
          print("Gefundene Summe: " + line.text);
          sum = double.parse(line.text.replaceAll(",", "."));
        }
      }
    }

    return Invoice(sum);
  }

  void scanSumAndDisplay() async {
    var inv = await scanInvoice();
    setState(() {
      _guiSum = inv.sum;
    });
  }

  void saveOcrData() {
    Firestore.instance
        .collection('user')
        .document(widget.user.uid)
        .collection('invoices')
        .document(fileId)
        .setData({'date': DateTime.now(), 'market': 'lidl', 'sum': 10.20});
  }
}
