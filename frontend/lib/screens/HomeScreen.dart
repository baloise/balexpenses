import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/screens/ResultScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Invoices.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserInfo user;

  String result;

  getResult() {
    Firestore.instance
        .collection('user')
        .document(user.uid)
        .get()
        .then((snapshot) {
      print(snapshot);
      setState(() {
        result = snapshot['2020'].toString();
      });
    });
  }

  void _setUser(u) {
    setState(() {
      this.user = u;
    });
  }

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
            ResultScreen(user: user, result: result, getResult: getResult),
            Text(this.user != null ? user.email : '-'),
            RaisedButton(
              child: Text("erfasse Kassenzettel"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Invoices(user: user)),
                );
              },
            )
          ],
        ));
  }
}
