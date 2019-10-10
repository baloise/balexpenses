import 'dart:io';

import 'package:balexpenses/models/Invoice.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class OcrService with ChangeNotifier {
  // credits: https://medium.com/@teresa.wu/googles-ml-kit-text-recognition-with-sample-app-of-receipts-reading-7fe6dc68ada3
  Future<Invoice> scanInvoice(File image) async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    double maxNumber = maxNumberInText(visionText.text);
    var invoiceDate = findDate(visionText.text);
    String store = findStore(visionText);
    return Invoice(store, maxNumber, invoiceDate);
  }

  double maxNumberInText(String text) {
    List<double> allNumbers = findNumbers(text);
    double result = -1;
    if (allNumbers != null && allNumbers.isNotEmpty) {
      result = allNumbers.reduce(max);
    }
    return result;
  }

  List<double> findNumbers(String text) {
    List<double> result = [];
    if (text != null && text.isNotEmpty) {
      RegExp exp = new RegExp(r"[+-]?([0-9]*[,])?[0-9]+");
      Iterable<RegExpMatch> matches = exp.allMatches(text);

      result = matches
          .map((match) =>
              text.substring(match.start, match.end).replaceAll(",", "."))
          .where((str) => str.contains("."))
          .map((str) => double.parse(str))
          .toList();
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
        var dayString = match.group(1);
        var monthString = match.group(2);
        var yearString = match.group(3);
        int year = int.parse(yearString);
        year = (year < 100) ? year + 2000 : year;
        result = DateTime(year, int.parse(monthString), int.parse(dayString));
      }
    }
    return result;
  }
  String findStore(VisionText visionText) {
    String result;
    var storeMap = {
      'LDL': 'LIDL',
      'ALDI': 'ALDI',
      'HIEBER': 'HIEBER',
      'ENGEL': 'Engel Apotheke',
      'hirsch': 'Hirsch Apotheke',
    };
    List<String> wellKnownStores = storeMap.keys.toList();

    List<String> storesFromText = visionText.blocks
        .map((block) => block.lines.map((ln) => ln.text))
        .expand((it) => it)
        .map((it) => wellKnownStores.firstWhere((store) => it.contains(store), orElse: () => "-"))
        .where((it) => it != '-')
        .toList();

    if (storesFromText.length > 0) {
      result = storeMap[storesFromText.first];
    }
    if (result == null) {
      result = 'unknown';
    }
    return result;
  }
}
