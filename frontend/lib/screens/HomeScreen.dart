import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _signInAnonymously() async {
    try {
      final FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: 'timo@klueber.email', password: '12345678'))
          .user;

      print(user.email);
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Baloise expenses"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: _signInAnonymously,
              child: Text("Anonymes Login"),
            ),
            Text("Baloise expenses"),
            Text("USER"),
          ],
        ),
      ),
    );
  }
}
