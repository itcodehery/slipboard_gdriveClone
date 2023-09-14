import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/secondary/file_type.dart';
import 'package:netflix_clone/sharedprefshelper.dart';
import 'package:netflix_clone/sharprohelp.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  UploadPageState createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  @override
  void initState() {
    super.initState();
    getUploadedCards();
    getUploadTimeData();
  }

  //misc
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  //keys
  static const String uploadedEntriesKey = 'uploadedEntries';
  static const String uploadDateKey = 'uploadDate';

  //maps
  Map<String, String> yourUploadsList = {};
  Map<String, DateTime> uploadMeta = {};

  //functions
  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {
      yourUploadsList.addAll({
        pickedFile!.name.split('.').first: pickedFile!.name.split('.').last
      });
      uploadMeta.addAll({pickedFile!.name: DateTime.now()});
      SharedPrefMapHelper.saveMap(uploadDateKey, uploadMeta);
      SharedPreferencesHelper.saveMap(yourUploadsList, uploadedEntriesKey);
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    debugPrint('Download link: $urlDownload');

    uploadMeta = await SharedPreferencesHelper.getUploadTimeMap(uploadDateKey);
    yourUploadsList = await SharedPreferencesHelper.getMap(uploadedEntriesKey);
    dateTimeSubtitle = Text(
        "${uploadMeta[pickedFile!.name]!.hour.toString()}: ${uploadMeta[pickedFile!.name]!.minute.toString()} on ${uploadMeta[pickedFile!.name]!.day.toString()}/${uploadMeta[pickedFile!.name]!.month.toString()}");
    setState(() {
      uploadTask = null;
      pickedFile = null;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowCompression: true);
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  //initialization functions
  void getUploadedCards() async {
    Map<String, String> uploadList =
        await SharedPreferencesHelper.getMap(uploadedEntriesKey);
    if (uploadList.isNotEmpty) {
      setState(() {
        yourUploadsList = uploadList;
      });
    }
  }

  void getUploadTimeData() async {
    Map<String, DateTime> uploadData =
        await SharedPrefMapHelper.getMap(uploadDateKey);
    if (uploadMeta.isNotEmpty) {
      setState(() {
        uploadMeta = uploadData;
      });
    }
  }

  //main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                '  Upload Files:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                    leading: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      color: fileColorMap[pickedFile == null
                          ? 'unk'
                          : pickedFile!.name.split('.').last],
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                        child: Text(
                          pickedFile == null
                              ? ' > '
                              : pickedFile!.name.split('.').last.toUpperCase(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    title: SizedBox(
                      width: 130,
                      child: Text(
                          pickedFile == null
                              ? 'Select a file'
                              : pickedFile!.name,
                          overflow: TextOverflow.ellipsis),
                    ),
                    subtitle: uploadTask == null
                        ? null
                        : buildProgress(
                            fileColorMap[pickedFile == null
                                ? 'unk'
                                : pickedFile!.name.split('.').last],
                          )),
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              //   child: Divider(
              //     color: Colors.grey,
              //   ),
              // ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SlipActionButton(
                    backgroundColor: Colors.indigo.shade400,
                    buttonText: 'Select File',
                    onPress: selectFile,
                  ),
                  const SizedBox(width: 10),
                  SlipActionButton(
                      backgroundColor: Colors.grey.shade800,
                      buttonText: 'Upload File',
                      onPress: pickedFile == null ? showSnacky : uploadFile),
                  const SizedBox(width: 6)
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Divider(
                  color: Colors.grey.shade700,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('  Your uploads:'),
                  TextButton(
                    onPressed: () {
                      //this function should clear all the entries in uploadedfiles
                      setState(() {
                        yourUploadsList.clear();
                        uploadMeta.clear();
                        SharedPrefMapHelper.saveMap(uploadDateKey, uploadMeta);
                        SharedPreferencesHelper.saveMap(
                            yourUploadsList, uploadedEntriesKey);
                      });
                    },
                    child: const Icon(Icons.clear_all, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              yourUploadsList.isEmpty
                  ? myUploadNull()
                  : YourUploadsBuilder(
                      yourUploadsList: yourUploadsList,
                      myUploadCard: myUploadCard)
            ]),
      ),
    );
  }

  dynamic showSnacky() {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red.shade400,
        content: const Text(
          'Select a file first!',
          style: TextStyle(color: Colors.white),
        )));
  }

  Widget dateTimeSubtitle = const Text('upload date unknown');

  Widget myUploadCard(String title, String fileType) {
    return Card(
      child: ListTile(
        leading: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          color: fileColorMap[fileType],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
            child: Text(
              fileType.toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        title: SizedBox(
            width: 60,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
            )),
        subtitle: dateTimeSubtitle,
      ),
    );
  }

  Widget myUploadNull() {
    return const Card(
      child: ListTile(
        title: Text('Nothing uploaded by you yet.'),
        titleAlignment: ListTileTitleAlignment.center,
      ),
    );
  }

  Widget buildProgress(Color? color) => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            if (progress == 1) {
              return Text(
                'Upload completed!',
                style: TextStyle(color: color),
              );
            } else {
              return SizedBox(
                height: 5,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.black12,
                  color: color,
                ),
              );
            }
          } else {
            return const SizedBox(
              height: 1,
            );
          }
        },
      );
}

class SlipActionButton extends StatelessWidget {
  const SlipActionButton({
    super.key,
    required this.backgroundColor,
    required this.buttonText,
    required this.onPress,
  });

  final Color backgroundColor;
  final String buttonText;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)))),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(backgroundColor)),
        onPressed: onPress,
        child: Text(buttonText));
  }
}

class YourUploadsBuilder extends StatelessWidget {
  const YourUploadsBuilder(
      {Key? key, required this.yourUploadsList, required this.myUploadCard})
      : super(key: key);
  final Map<String, String> yourUploadsList;
  final Function myUploadCard;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: yourUploadsList.length,
        itemBuilder: (context, index) {
          return myUploadCard(yourUploadsList.entries.elementAt(index).key,
              yourUploadsList.entries.elementAt(index).value);
        });
  }
}
