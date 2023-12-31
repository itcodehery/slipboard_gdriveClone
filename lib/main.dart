import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix_clone/pages/about.dart';
import 'package:netflix_clone/pages/search.dart';
import 'package:netflix_clone/pages/upload_page.dart';
import 'widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:material3_layout/material3_layout.dart';
import 'package:netflix_clone/pages/home.dart';
import 'package:netflix_clone/pages/files.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
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
      home: const Scaffold(body: WidgetTree()),
      routes: {
        'About': (context) => const AboutPage(),
        'Search': (context) => const Search(),
        'Files': (context) => const Files(),
        'Upload': (context) => const UploadPage(),
      },
    );
  }
}

class ClipBoardHomePage extends StatelessWidget {
  ClipBoardHomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userUID() {
    return Text(
      user?.email ?? 'User email',
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
        onPressed: signOut,
        style: const ButtonStyle(elevation: MaterialStatePropertyAll(0)),
        child: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Sign Out';
    String title2 = 'About';

    return NavigationScaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size(10, 80),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              color: Colors.black38,
              child: ListTile(
                title: const Text(
                  'Search for files',
                  style: TextStyle(
                      fontFamily: 'SFProDisplay', color: Colors.white38),
                ),
                trailing: const Icon(Icons.search, color: Colors.white24),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed('Search'),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Slipboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Text(
                  'Signed in as ',
                  style: TextStyle(fontSize: 14),
                ),
                _userUID()
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(
                  value: title,
                  child: Text(title),
                ),
                PopupMenuItem<String>(
                  value: title2,
                  child: Text(title2),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 'Sign Out':
                  signOut();
                case 'About':
                  Navigator.of(context).pushNamed('About');
              }
            },
          ),
        ],
      ),
      navigationSettings: RailAndBottomSettings(pages: <Widget>[
        const Home(),
        const Files(),
        const UploadPage(),
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
          tooltip: 'View all files',
        ),
        DestinationModel(
            label: 'Upload',
            icon: const Icon(Icons.upload_file),
            selectedIcon: const Icon(Icons.upload_file_rounded),
            tooltip: 'Upload a file')
      ]),
      navigationType: NavigationTypeEnum.railAndBottomNavBar,
      theme: Theme.of(context),
    );
  }
}
