import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _signInWithEmailAndPassword() async {
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

  Future<void> _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
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
            Text("Baloise expenses"),
            RaisedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text("Sign in with email/password"),
            ),
            RaisedButton(
              onPressed: _signInWithGoogle,
              child: Text("Sign in with Google"),
            ),
            Text("USER"),
          ],
        ),
      ),
    );
  }
}
