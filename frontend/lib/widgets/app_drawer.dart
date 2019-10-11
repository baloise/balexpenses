import 'package:balexpenses/providers/auth_service.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final User user;
  final Function signout;

  AppDrawer({this.user, this.signout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName != null ? user.displayName : ''),
            accountEmail: Text(user?.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user.avatar != null
                  ? NetworkImage(user.avatar)
                  : AssetImage('assets/images/default-user.png'),
            ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.highlight_off),
                SizedBox(
                  width: 10,
                ),
                Text("Logout"),
              ],
            ),
            onTap: signout,
          ),
        ],
      ),
    );
  }
}
