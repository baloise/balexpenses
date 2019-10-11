import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'auth_service.dart';

class StateProvider with ChangeNotifier {

  final List<MapEntry<String, dynamic>> _result = [];
  UnmodifiableListView<MapEntry<String, dynamic>> get result => UnmodifiableListView(_result);

  void setResult(List<MapEntry<String, dynamic>> newStuff) {
    _result.clear();
    _result.addAll(newStuff);
    this.notifyListeners();
  }

  getResult(User user) {
    if (user == null) {
      return;
    }
    List<MapEntry<String, dynamic>> entries = [];
    Firestore.instance
        .collection('user')
        .document(user.uid)
        .get()
        .then((snapshot) {
      if (snapshot != null) {
        entries = snapshot.data.entries.toList();
      } else {
        print("No Snapshot");
      }
      setResult(entries);
    });
  }

}
