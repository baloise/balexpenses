import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/screens/ResultScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Invoices.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserInfo user;

  String result;

  getResult() {
    Firestore.instance
        .collection('user')
        .document(user.uid)
        .get()
        .then((snapshot) {
      print(snapshot);
      setState(() {
        result = snapshot['2020'].toString();
      });
    });
  }

  void _setUser(u) {
    setState(() {
      this.user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName:
                    Text(_user.displayName != null ? _user.displayName : ''),
                accountEmail: Text(_user?.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: _user.avatar != null
                      ? NetworkImage(_user.avatar)
                      : AssetImage('assets/images/default-user.png'),
                ),
              ),
              ListTile(
                title: Text("Logout"),
                onTap: () => auth.signOut(),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Baloise expenses"),
        ),
        body: Column(
          children: <Widget>[
            Invoices(
              user: user,
            ),
            ResultScreen(user: user, result: result, getResult: getResult),
            Text(this.user != null ? user.email : '-'),
          ],
        ));
  }
}
