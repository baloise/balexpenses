import 'package:balexpenses/screens/AuthScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Baloise expenses", key: Key('homeScreen_title')),
        ),
        body: AuthScreen());
  }
}
