import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/screens/ResultScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Invoices.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Baloise expenses"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => auth.signOut(),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Invoices(
              user: null,
            ),
            RaisedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ResultScreen(),//
                )
              ),
              child: Text("Results"),
            ),
            Consumer<User>(
              builder: (ctx, user, child) {
                return Text(user != null ? user.email : 'User: -');
              },
            ),
          ],
        ));
  }
}
