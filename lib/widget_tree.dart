import 'package:flutter/material.dart';
import 'package:netflix_clone/main.dart';
import 'package:netflix_clone/pages/home.dart';
import 'auth.dart';
import 'pages/login_register_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ClipBoardHomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
