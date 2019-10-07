import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
          RaisedButton(
            onPressed: _signOut,
            child: Text("Sign out"),
          ),
          Text("USER"),
        ],
      ),
    );
  }

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

  Future<void> _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
  }
}
