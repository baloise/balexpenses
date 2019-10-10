import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/widgets/login_button.dart';
import 'package:balexpenses/widgets/login_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoginField(
                  label: 'Email',
                ),
                SizedBox(height: 5.0),
                LoginField(
                  label: 'Password',
                ),
                SizedBox(height: 20.0),
                LoginButton(
                    icon: Icons.email,
                    color: Colors.blue,
                    text: "E-Mail Login",
                    // todo: use credentials from textfields
                    function: () => auth.signInWithEmailAndPassword(
                        'timo@klueber.email', '12345678')),
                SizedBox(height: 5.0),
                LoginButton(
                    icon: Icons.perm_contact_calendar,
                    color: Colors.red,
                    text: "Google Login",
                    function: () => auth.signInWithGoogle()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
