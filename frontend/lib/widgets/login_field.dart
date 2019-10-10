import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  // todo: use global theme
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final String label;

  LoginField({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
