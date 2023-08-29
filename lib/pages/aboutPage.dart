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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
            const Text('Made by '),
            const Text(
              'Hari Prasad',
              style: TextStyle(fontSize: 24),
            ),
            const Text('Christ Academy Institute for Advanced Studies'),
            Divider(
              color: Colors.grey.shade700,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                    onPressed: launchGithubURL,
                    style: const ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
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
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 42, 165, 77))),
                    icon: const Icon(
                      Icons.link,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'My Linktree',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
