import 'package:balexpenses/screens/HomeScreen.dart';
import 'package:balexpenses/providers/ocr_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: OcrService()),
        ],
        child: MyApp(),
      )
  );
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
      home: HomeScreen(),
    );
  }
}
