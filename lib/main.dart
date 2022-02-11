import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_councel/services/movie_data.dart';
import 'package:movie_councel/services/personalize_service.dart';
import 'package:movie_councel/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthService(),
        ),
        ChangeNotifierProvider.value(
          value: MovieData(),
        ),
        ChangeNotifierProvider.value(
          value: PersonalizeService(),
        )
      ],
      child: Consumer<AuthService>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Movie Guide',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth
              ? const MyHomePage(title: 'Movie Guide')
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : const LoginScreen(),
                ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: ChangeNotifierProvider(
          create: (BuildContext context) => MovieData(),
          child: const MainScreen(),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
