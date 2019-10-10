import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  // todo: use global theme
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final String label;
  final Function setValue;
  final bool hideText;
  final FormFieldValidator<String> fieldValidator;

  LoginField(
      {Key key,
      this.label,
      this.setValue,
      this.fieldValidator,
      this.hideText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hideText,
      autofocus: false,
      style: style,
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        setValue(value);
      },
      validator: fieldValidator,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
