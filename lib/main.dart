import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material3_layout/material3_layout.dart';
import 'package:netflix_clone/home.dart';
import 'package:netflix_clone/files.dart';

void main() {
  runApp(const ClipBoard());
}

class ClipBoard extends StatefulWidget {
  const ClipBoard({Key? key}) : super(key: key);

  @override
  ClipBoardState createState() => ClipBoardState();
}

class ClipBoardState extends State<ClipBoard> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'SFProDisplay',
          canvasColor: Colors.black87,
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Colors.grey[700]!,
              onPrimary: Colors.white,
              secondary: Colors.grey.shade600,
              onSecondary: Colors.white,
              error: Colors.redAccent,
              onError: Colors.white,
              background: Colors.black87,
              onBackground: Colors.white,
              surface: Colors.grey.shade900,
              onSurface: Colors.white)),
      home: const ClipBoardHomePage(),
    );
  }
}

class ClipBoardHomePage extends StatelessWidget {
  const ClipBoardHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationScaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size(10, 10),
          child: SizedBox(height: 10),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'CHRIST',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            Text('Slipboard')
          ],
        ),
        centerTitle: true,
      ),
      navigationSettings: RailAndBottomSettings(pages: <Widget>[
        const Home(),
        const Files()
      ], destinations: [
        DestinationModel(
          label: 'Home',
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          tooltip: 'Home page',
        ),
        DestinationModel(
          label: 'Files',
          icon: const Icon(Icons.file_copy_outlined),
          selectedIcon: const Icon(Icons.file_copy),
          tooltip: 'Users page',
        ),
      ]),
      navigationType: NavigationTypeEnum.railAndBottomNavBar,
      theme: Theme.of(context),
    );
  }
}
