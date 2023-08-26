import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/secondary/file_type.dart';
import 'package:netflix_clone/secondary/subjects.dart';
import 'package:netflix_clone/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

final User? user = Auth().currentUser;

Future<void> signOut() async {
  await Auth().signOut();
}

Widget _userUID() {
  return Text(
    user?.email ?? 'User email',
    style: const TextStyle(fontSize: 12),
  );
}

Widget _signOutButton() {
  return const ElevatedButton(
      onPressed: signOut,
      child: Text(
        'Sign Out',
        style: TextStyle(color: Colors.white),
      ));
}

List<Subjects> subjectList = [
  Subjects.cpp,
  Subjects.discreteStructures,
  Subjects.webTech,
  Subjects.holisticDev
];

class HomeState extends State<Home> {
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
                  const Text('  Recently Uploaded:'),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: 3,
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
                  const SizedBox(height: 10),
                  const Text('  Your Subjects:'),
                  const SizedBox(height: 10),
                  for (Subjects a in subjectList) SubjectCard(subject: a)
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
      //     body: Padding(
      //   padding: const EdgeInsets.all(10),
      //   child: ListView(
      //     children: [
      //       const SizedBox(height: 10),
      //       const Text('  Recently Uploaded:'),
      //       const SizedBox(height: 10),
      //       RecentlyAddedFileCard(
      //         fileType: FileType.pdf,
      //         title: 'Web Tech Notes',
      //         uploaderStudent: 'Sruti',
      //         uploadedTime: const TimeOfDay(hour: 12, minute: 45),
      //       ),
      //       RecentlyAddedFileCard(
      //         title: 'C++ Important Questions',
      //         fileType: FileType.ppt,
      //         uploaderStudent: 'Abin',
      //         uploadedTime: const TimeOfDay(hour: 10, minute: 23),
      //       ),
      //       RecentlyAddedFileCard(
      //         title: 'DS Project Teams',
      //         fileType: FileType.xlsx,
      //         uploaderStudent: 'Karthik',
      //         uploadedTime: const TimeOfDay(hour: 8, minute: 45),
      //       ),
      //       const SizedBox(height: 10),
      //       const Text('  Your Subjects:'),
      //       const SizedBox(height: 10),
      //       for (Subjects a in subjectList) SubjectCard(subject: a)
      //     ],
      //   ),
      // )
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

class RecentlyAddedFileCard extends StatelessWidget {
  RecentlyAddedFileCard({
    super.key,
    required this.title,
    required this.fileType,
    required this.uploaderStudent,
    required this.uploadedTime,
  });

  final String title;
  final FileType fileType;
  final String uploaderStudent;
  final TimeOfDay uploadedTime;

  String convertFileTypetoString(FileType fileType) {
    switch (fileType) {
      case FileType.doc:
        return 'DOC';
      case FileType.docx:
        return 'DOCX';
      case FileType.pdf:
        return 'PDF';
      case FileType.ppt:
        return 'PPT';
      case FileType.xlsx:
        return 'XLSX';
      default:
        return 'UNK';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: const Icon(Icons.download),
        title: Row(
          children: [
            Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                color: fileColors[fileType],
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                    child: Text(
                      convertFileTypetoString(fileType),
                      style: const TextStyle(color: Colors.black),
                    ))),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            )
          ],
        ),
        subtitle: Row(
          children: [
            const Text('Uploaded by '),
            Text(uploaderStudent,
                style: const TextStyle(fontStyle: FontStyle.italic)),
            const Text(' at '),
            Text(uploadedTime.format(context))
          ],
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({Key? key, required this.subject}) : super(key: key);

  final Subjects subject;

  String convertSubjecttoString(Subjects subject) {
    switch (subject) {
      case Subjects.cpp:
        return 'C++';
      case Subjects.discreteStructures:
        return 'Discrete Structures';
      case Subjects.webTech:
        return 'Web Technologies';
      case Subjects.holisticDev:
        return 'Holistic Development';
      default:
        return '-Unbound Subject-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Card(
              color: subjectColorMap[subject],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: const SizedBox(
                height: 14,
                width: 20,
              ),
            ),
            Text('  ${convertSubjecttoString(subject)}',
                style: const TextStyle(fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
