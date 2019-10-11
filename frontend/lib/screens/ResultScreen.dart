import 'package:balexpenses/providers/auth_service.dart';
import 'package:balexpenses/screens/ResultItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balexpenses/providers/state_provider.dart';

class ResultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final StateProvider stateProvider = Provider.of<StateProvider>(context);
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Results Screen"),
      ),
      body: StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (_, AsyncSnapshot<User> snapshot) {
          User user;
          if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
            user = snapshot.data;
          }
          return Consumer<StateProvider>(
            builder: (ctx, state, child) {
              return Center(
                child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                            (user != null)
                                ? "UserId: ${snapshot.data.uid}"
                                : "UserId: -"
                        ),
                        Column(
                          children: <Widget>[
                            ...(state.result.map((it) =>
                                ResultItem("${it.key}=${it.value}")).toList()),
                          ],
                        ),
                        RaisedButton(
                          child: Text('get Result'),
                          onPressed: () => stateProvider.getResult(user),
                        ),
                      ],
                    )
                ),
              );
            },
          );

          return Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    (user != null) ? "UserId: ${snapshot.data.uid}" : "UserId: -"
                  ),
                  Consumer<StateProvider>(
                    builder: (ctx, state, child) {
                      return Column(
                        children: <Widget>[
                          ...(state.result.map((it) => ResultItem("${it.key}=${it.value}")).toList()),
                        ],
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text('get Result'),
                    onPressed: () => stateProvider.getResult(user),
                  ),
                ],
              )
            ),
          );
        },
      ),
    );
  }
  Widget build2(BuildContext context) {
    final StateProvider stateProvider = Provider.of<StateProvider>(context);
    final FirebaseAuthService auth = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Results Screen"),
      ),
      body: StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (_, AsyncSnapshot<User> snapshot) {
          User user;
          if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
            user = snapshot.data;
          }
          return Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    (user != null) ? "UserId: ${snapshot.data.uid}" : "UserId: -"
                  ),
                  RaisedButton(
                    child: Text('get Result'),
                    onPressed: () => stateProvider.getResult(user),
                  ),
              Consumer<StateProvider>(
                builder: (ctx, state, child) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.result.length,
                    itemBuilder: (context, index) {
                      return ResultItem([state.result.elementAt(index)].map((it) => "${it.key}=${it.value}").first);
//                      return ListTile(
//                        title: ResultItem([state.result.elementAt(index)].map((it) => "${it.key}=${it.value}").first),
//                      );
                    },
                  );
                },
              ),
/*
                  Consumer<StateProvider>(
                    builder: (ctx, state, child) {
                      return Column(
                        children: <Widget>[
                          ...(state.result.map((it) => ResultItem("${it.key}=${it.value}")).toList()),
                        ],
                      );
                    },
                  ),
*/

                ],
              )
            ),
          );
        },
      ),
    );
  }
}
