import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseUser user;

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
          RaisedButton(
            onPressed: () {
              print(user.email);
            },
            child: Text("debug"),
          ),
          Text(this.user != null ? user.email : '-'),
        ],
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    var u = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: 'timo@klueber.email', password: '12345678'))
        .user;
    print(u.email);
    try {
      setState(() {
        this.user = u;
      });
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

    var u = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + u.displayName);
    setState(() {
      this.user = u;
    });
  }

  Future<void> _signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
    setState(() {
      this.user = null;
    });
  }
}
