import 'dart:io';

import 'package:balexpenses/models/Invoice.dart';
import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/providers/ocr_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

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
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://balexpenses-bbaae.appspot.com/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[Text('test2')]),
      bottomNavigationBar: BottomBar(getImage: _getImage),
      body: Column(
        children: <Widget>[
          _invoice != null
              ? InvoiceProperties(
                  invoice: _invoice,
                  user: widget.user,
                  fileId: fileId,
                )
              : Text(''),
          Container(
            width: 300,
            height: 300,
            child: _image != null
                ? PhotoView(
                    imageProvider: FileImage(_image),
                  )
                : Icon(Icons.add_to_home_screen),
          ),
//          FittedBox(
//            child: _image != null
//                ? Image.file(_image)
//                : Center(child: Icon(Icons.hourglass_empty)),
//            fit: BoxFit.fill,
//          ),
        ],
      ),
    );
  }

  Future _getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    fileId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _invoice = null;
      _image = image;
    });
    scanSumAndDisplay();
  }

  Future _clear() async {
    setState(() {
      _image = null;
    });
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
    var inv = await Provider.of<OcrService>(this.context, listen: false)
        .scanInvoice(_image);
    setState(() {
      _invoice = inv;
    });
  }
}

class InvoiceProperties extends StatelessWidget {
  final Invoice invoice;
  final User user;
  final String fileId;

  InvoiceProperties({
    this.invoice,
    this.user,
    this.fileId,
  });

  Future<void> saveOcrData() {
    print('****');

    var data = {
      'date': invoice?.date,
      'market': invoice?.store,
      'sum': invoice?.sum
    };

    print(data);
    return Firestore.instance
        .collection('user')
        .document(user.uid)
        .collection('invoices')
        .document(fileId)
        .setData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue[300],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                OcrResultProperty(label: "Markt", value: invoice?.store),
                OcrResultProperty(
                    label: "ermittelte Summe:", value: invoice?.sum),
                OcrResultProperty(label: "Datum:", value: invoice?.date),
                MaterialButton(
                  child: Row(
                      children: <Widget>[Icon(Icons.check), Text('senden')]),
                  onPressed: this.saveOcrData,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OcrResultProperty extends StatelessWidget {
  final String empty = '-';

  final String label;
  final Object value;

  OcrResultProperty({this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(label),
        SizedBox(
          width: 10,
        ),
        value != null ? Text(value.toString()) : Text(empty),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  final Function getImage;

  BottomBar({this.getImage});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
    );
  }
}
