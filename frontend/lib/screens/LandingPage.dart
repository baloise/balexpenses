import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/screens/AuthScreen.dart';
import 'package:balexpenses/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (_, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return AuthScreen();
          }
          return Provider<User>.value(
            value: user,
            child: HomeScreen(),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
