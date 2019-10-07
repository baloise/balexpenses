import 'package:balexpenses/screens/AuthScreen.dart';
import 'package:balexpenses/screens/InvoiceSelection.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Baloise expenses"),
        ),
        body: Column(
          children: <Widget>[
            AuthScreen(),
            InvoiceSelection(),
          ],
        ));
  }
}
