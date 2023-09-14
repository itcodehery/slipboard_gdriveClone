import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Future<void> launchGithubURL() async {
    Uri url = Uri.parse(
        'https://github.com/itcodehery'); // Replace with your desired URL

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchLinkTreeURL() async {
    Uri url = Uri.parse(
        'https://linktr.ee/itwritshery'); // Replace with your desired URL

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            const Text('Slipboard',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold)),
            const Text('The Student Clipboard', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Divider(
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Made by '),
            const Text(
              'Hari Prasad',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text('from Christ Academy Institute for Advanced Studies'),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade700,
              height: 20,
            ),
            Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Me:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                          onPressed: launchGithubURL,
                          style: const ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6)))),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blueGrey)),
                          // icon: const Icon(
                          //   Icons.verified_sharp,
                          //   color: Colors.white,
                          // ),
                          icon: Image.asset(
                            'assets/github-mark-white.png',
                            fit: BoxFit.contain,
                            height: 20,
                            width: 20,
                          ),
                          label: const Text(
                            'My Github',
                            style: TextStyle(color: Colors.white),
                          )),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                          onPressed: launchLinkTreeURL,
                          style: const ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6)))),
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 42, 165, 77))),
                          icon: const Icon(
                            Icons.link,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'My Linktree',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ]),
            Divider(
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 10),
            const Flex(
              direction: Axis.vertical,
              children: [
                Text(
                    'Slipboard is an app that helps students store their notes in one central database from which the whole class can access the notes. With Slipboard, students can easily upload, organize, and share their notes with their classmates, as well as search for relevant notes from other students. Slipboard is designed to enhance the learning experience of students by providing them with a convenient and efficient way to manage their notes.'),
                SizedBox(height: 20),
                Text(
                    'This app was made using Google\'s Flutter Cross Platform Frontend Framework with the Dart Programming Language and Firebase noSQL database to store data.'),
                SizedBox(
                  height: 40,
                ),
                Text('2023 Hari Prasad ©'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
