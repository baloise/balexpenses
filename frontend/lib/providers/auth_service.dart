import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.displayName,
    this.avatar,
  });

  final String uid;
  final String email;
  final String displayName;
  final String avatar;
}

class FirebaseAuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebase(user));
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return _userFromFirebase(authResult.user);
      }
    }
  }

  Future<void> signOut() async {
    print(await _firebaseAuth.currentUser());

    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    return _firebaseAuth.signOut();
  }

  User _userFromFirebase(UserInfo user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      avatar: user.photoUrl,
    );
  }
}
