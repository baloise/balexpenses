import 'package:balexpenses/provider_setup.dart' as prefix0;
import 'package:balexpenses/screens/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: prefix0.providers,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baloise expenses',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.white,
      ),
      home: LandingPage(),
    );
  }
}
