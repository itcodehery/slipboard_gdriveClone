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
                children: [
                  const SizedBox(height: 10),
                  const Text('  Recently Uploaded:'),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: files.length > 3 ? 3 : files.length,
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                            SizedBox(
                              width: 140,
                              child: Text(
                                file.name.split('.').first,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ]),
                          subtitle: const Row(
                            children: [Text('file time '), Text('file date')],
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
                  const SizedBox(height: 10),
                  const Text('  Your Subjects:'),
                  const SizedBox(height: 10),
                  for (Subjects a in subjectList) SubjectCard(subject: a)
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Could not retrieve data! Check your Connection!'));
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
