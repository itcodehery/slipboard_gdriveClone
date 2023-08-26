import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class Files extends StatefulWidget {
  const Files({Key? key}) : super(key: key);

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.upload),
            label: const Text('Upload')),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        body: FutureBuilder(
          future: futureFiles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final files = snapshot.data!.items;
              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return ListTile(
                    title: Text(file.name),
                    trailing: IconButton(
                        onPressed: () {
                          downloadFile(file);
                        },
                        icon: const Icon(Icons.download)),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error occured!'));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Downloading ${ref.name}')));

    await ref.writeToFile(file);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Downloaded ${ref.name}')));
  }
}
