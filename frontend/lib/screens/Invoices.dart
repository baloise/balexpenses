import 'dart:io';
import 'package:intl/intl.dart';
import 'package:balexpenses/models/Invoice.dart';
import 'package:balexpenses/screens/InvoiceSelection.dart';
import 'package:balexpenses/providers/ocr_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';


class Invoices extends StatefulWidget {
  final user;

  const Invoices({this.user});

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  File _image;
  String fileId;
  Invoice _invoice;
  List recognitions;
  
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://balexpenses-bbaae.appspot.com/');

  void loadModel() async {
    String res = await Tflite.loadModel(
        model: "assets/retrained_graph.lite",
        labels: "assets/retrained_labels.txt",
        numThreads: 1 // defaults to 1
    );
  }

  @override
  Widget build(BuildContext context) {
    loadModel();
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
      Container(child:Center(
        child: recognitions != null
          ? Column(children: <Widget>[
              ...recognitions
                .where((i) => i['label'] != '').toList()
                  .map((r) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(r['label'] != null ? r['label'] : ''),
                      Text(r['confidence'] != null ? r['confidence'].toString() : ''),
                    ],
                  ),)
            ])
          : Container(),
      ),
      ),
      Text(_invoice == null ? "-" : "Store: ${_invoice.store}"),
      Text(_invoice == null ? "-" : "Ermittelte Summe: ${_invoice.sum.toString()} EUR"),
      Text(_invoice == null ? "-" : "${new DateFormat('dd-MM-yyyy').format(_invoice.date)}"),
      InvoiceSelection(
          user: widget.user,
          image: _image,
          startUpload: _startUpload,
          getImage: _getImage),
      RaisedButton(
        onPressed: _image == null ? null : scanSumAndDisplay,
        child: Text("Scan Invoice"),

      ),
      RaisedButton(
        child: Text('abc'),
        onPressed: () => saveOcrData(_invoice),
      )
    ]);
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileId = DateTime.now().millisecondsSinceEpoch.toString();

    var result = await Tflite.runModelOnImage(
        path: image. path,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );

    setState(() {
      recognitions = result;
      _invoice = null;
      _image = image;
    });
    await Tflite.close();
  }

  void _startUpload() {
    var fileExtension = basename(_image.path).split('.').last;

    String filePath = "invoices/${widget.user.uid}/$fileId.$fileExtension";
    _storage.ref().child(filePath).putFile(_image);
  }

  void scanSumAndDisplay() async {
    setState(() {
      _invoice = null;
    });
    var inv = await Provider.of<OcrService>(this.context, listen: false).scanInvoice(_image);
    setState(() {
      _invoice = inv;
    });
  }

  void saveOcrData(Invoice invoice) {
    var data = {'date': invoice.date, 'market': 'lidl', 'sum': invoice.sum};
    Firestore.instance
        .collection('user')
        .document(widget.user.uid)
        .collection('invoices')
        .document(fileId)
        .setData(data);
  }
}
