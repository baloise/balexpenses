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
                                ? snapshot.data.email
                                : "No User",
                          style: TextStyle(fontSize: 20),
                        ),
                        RaisedButton(
                          child: Text('Retrieve Result Data', style: TextStyle(color: Colors.white),),
                          color: Theme.of(context).buttonTheme.colorScheme.background,
                          onPressed: () => stateProvider.getResult(user),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: state.result.length,
                            itemBuilder: (context, index) {
                              var it = state.result.elementAt(index);
                              return ResultItem(it.key, it.value.toString());
                            },
                          ),
                        ),
                      ],
                    )
                ),
              );
            },
          );


        },
      ),
    );
  }
}
