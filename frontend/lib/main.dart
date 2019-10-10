import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/providers/ocr_service.dart';
import 'package:balexpenses/screens/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: OcrService()),
      ChangeNotifierProvider.value(value: FirebaseAuthService()),
    ],
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
