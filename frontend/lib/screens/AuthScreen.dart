import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/widgets/login_button.dart';
import 'package:balexpenses/widgets/login_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> _key = new GlobalKey();

  String _email;
  String _password;
  bool _validate = false;

  setEmail(String value) {
    this._email = value;
  }

  setPassword(String value) {
    this._password = value;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validPassword(String value) {
    return (value.length < 3) ? "Password to short" : null;
  }

  bool _validateInputs() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      return true;
    } else {
      setState(() {
        this._validate = true;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _key,
            autovalidate: this._validate,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoginField(
                    label: 'Email',
                    setValue: setEmail,
                    fieldValidator: validateEmail,
                  ),
                  SizedBox(height: 5.0),
                  LoginField(
                    label: 'Password',
                    setValue: setPassword,
                    fieldValidator: validPassword,
                  ),
                  SizedBox(height: 20.0),
                  LoginButton(
                    icon: Icons.email,
                    color: Colors.blue,
                    text: "E-Mail Login",
                    function: () {
                      _validateInputs()
                          ? auth.signInWithEmailAndPassword(_email, _password)
                          : null;
                    },
                  ),
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
      ),
    );
  }
}
