import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:netflix_clone/pages/missing_page.dart';
import 'package:netflix_clone/secondary/file_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:netflix_clone/sharprohelp.dart';

class Files extends StatefulWidget {
  const Files({Key? key}) : super(key: key);

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  late Future<ListResult> futureFiles;
  Map<String, DateTime> futureUploadTimeMap = {};

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/files').listAll();
  }

  void getTimeMap() async {
    futureUploadTimeMap = await SharedPrefMapHelper.getMap('uploadDate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final files = snapshot.data!.items;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  const Text('  All Files:'),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: files.length,
                    reverse: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final reversedIndex = files.length - 1 - index;
                      final file = files[reversedIndex];
                      final fileref =
                          FirebaseStorage.instance.ref(file.fullPath);
                      final uploadTimeofFile = futureUploadTimeMap[file.name];

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
                            SizedBox(
                                width: 150,
                                child: Text(
                                  ' ${file.name.split('.').first}',
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ]),
                          subtitle: Row(
                            children: [
                              Text(uploadTimeofFile == null
                                  ? 'Upload time not found'
                                  : '${uploadTimeofFile.hour.toString()}:${uploadTimeofFile.minute.toString()}'),
                              Text(uploadTimeofFile == null
                                  ? ''
                                  : '${uploadTimeofFile.day.toString()}/${uploadTimeofFile.month.toString()}/${uploadTimeofFile.year.toString()}'),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                downloadFile(file);
                              },
                              icon: const Icon(Icons.download_for_offline)),
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
            return const MissingPage();
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
