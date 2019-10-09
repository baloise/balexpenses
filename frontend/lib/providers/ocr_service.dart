import 'dart:io';

import 'package:balexpenses/models/Invoice.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';

class OcrService with ChangeNotifier {

  Future<Invoice> scanInvoice(File image) async {
    double sum = -1;
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    Rect bb;
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.startsWith("S u")) {
          bb = line.boundingBox;
        }
        if (bb != null && !line.text.startsWith("S u") && (line.boundingBox.bottomLeft.dy - bb.bottomLeft.dy).abs() < 10.0) {
          print("Gefundene Summe: " + line.text);
          sum = double.parse(line.text.replaceAll(",", "."));
        }
      }
    }

    if (sum == -1) {
      print("*** Summe nicht gefunden !!!");
    }
    return Invoice(sum);
  }

}