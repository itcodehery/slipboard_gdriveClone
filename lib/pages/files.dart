import 'package:flutter/material.dart';

class Files extends StatefulWidget {
  const Files({Key? key}) : super(key: key);

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.upload),
            label: const Text('Upload')),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('Files from today:'),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Card(
                    color: Colors.white38,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 60),
                        child: Text('Herro')),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
