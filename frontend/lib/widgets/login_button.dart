import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final Function function;
  final String text;
  final IconData icon;

  // todo: use global theme
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  LoginButton({this.color, this.function, this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: color,
      child: MaterialButton(
        minWidth: 200,
        onPressed: function,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
