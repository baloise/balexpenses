import 'package:balexpenses/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baloise expenses',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.white,
      ),
      home: HomeScreen(),
    );
  }
}
