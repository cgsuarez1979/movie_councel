import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_councel/services/auth_service.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: const Text(
            'Movie Guide',
            textAlign: TextAlign.center,
          ),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        Consumer<AuthService>(builder: (ctx, auth, child) {
          return ListTile(
            leading: const Icon(FontAwesomeIcons.user),
            title: FutureBuilder(
              future: auth.getCurentUser(),
              builder: (ctx, AsyncSnapshot snapshot) => snapshot.hasData
                  ? Text(snapshot.data)
                  : const CircularProgressIndicator(),
            ),
            subtitle: GestureDetector(
                child: const Text("Logout"),
                onTap: () {
                  auth.logout();
                }),
          );
        })
      ],
    ));
  }
}
