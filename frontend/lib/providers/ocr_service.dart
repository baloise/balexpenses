import 'dart:io';

import 'package:balexpenses/models/Invoice.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class OcrService with ChangeNotifier {

  // credits: https://medium.com/@teresa.wu/googles-ml-kit-text-recognition-with-sample-app-of-receipts-reading-7fe6dc68ada3
  Future<Invoice> scanInvoice(File image) async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer = FirebaseVision.instance
        .textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(
        visionImage);

    List<double> allNumbers = findNumbers(visionText.text);
    double maxNumber = -1;
    if (allNumbers != null && allNumbers.isNotEmpty) {
      maxNumber = allNumbers.reduce(max);
    }
    var invoiceDate = findDate(visionText.text);
    return Invoice(maxNumber, invoiceDate);
  }

  List<double> findNumbers(String text) {
    List<double> result = [];
    if (text != null && text.isNotEmpty) {
      RegExp exp = new RegExp(r"[+-]?([0-9]*[,])?[0-9]+");
      Iterable<RegExpMatch> matches = exp.allMatches(text);

      result = matches
          .map((match) {
        return text.substring(match.start, match.end).replaceAll(",", ".");
      })
          .where((str) {
        return str.contains(".");
      })
          .map((str) {
        return double.parse(str);
      }).toList()
      ;
    }
    return result;
  }

  DateTime findDate(String text) {
    DateTime result;
    if (text != null && text.isNotEmpty) {
      RegExp exp = new RegExp(r"([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{2,4})");
      Iterable<RegExpMatch> matches = exp.allMatches(text);

      var match = matches.first;
     if (match != null) {
        var g1 = match.group(1);
        var g2 = match.group(2);
        var g3 = match.group(3);
        int year = int.parse(g3);
        year = (year < 100) ? year + 2000 : year;
        result = DateTime(year, int.parse(g2), int.parse(g1));
      }
    }
    return result;
  }

}