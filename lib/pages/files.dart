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

  Map<String, Color> fileColorMap = {
    'jpg': Colors.blueAccent.shade100,
    'png': Colors.blueAccent.shade100,
    'jpeg': Colors.blueAccent.shade100,
    'doc': Colors.blue.shade200,
    'docx': Colors.blue.shade200,
    'pdf': Colors.red.shade200,
    'ppt': Colors.orange.shade200,
    'xlsx': Colors.greenAccent.shade100
  };

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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('  All Files:'),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: files.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      final fileref =
                          FirebaseStorage.instance.ref(file.fullPath);
                      final Future<FullMetadata> fileMeta =
                          fileref.getMetadata();

                      return Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ListTile(
                          title: Row(children: [
                            Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                color: fileColorMap[
                                    file.name.split('.').last.toLowerCase()],
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                    child: Text(
                                      file.name.split(".").last.toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ))),
                            Text(file.name.split('.').first)
                          ]),
                          subtitle: const Row(
                            children: [Text('file time '), Text('file date')],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                downloadFile(file);
                              },
                              icon: const Icon(Icons.download)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Could not retrieve data!'));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
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
