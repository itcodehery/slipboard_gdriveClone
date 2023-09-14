import 'package:flutter/material.dart';
import 'package:netflix_clone/secondary/file_type.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  late ListResult allFiles;
  ListResult? searchedFiles;
  @override
  void initState() {
    super.initState();
    getallFiles();
  }

  void getallFiles() async {
    allFiles = await FirebaseStorage.instance.ref('/files').listAll();
  }

  Widget defaultSearch() {
    if (searchedFiles == null) {
      return const Center(
        child: Text('Search for anything'),
      );
    } else {
      return ListView.builder(
        itemCount: searchedFiles!.items.length,
        itemBuilder: (context, index) {
          Reference bello = searchedFiles!.items[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    color:
                        fileColorMap[bello.name.split('.').last.toLowerCase()],
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                        child: Text(
                          bello.name.split(".").last.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ))),
                title: Text(bello.name.split('.').first),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            allFiles.items.forEach((item) {
              if (item.name.contains(value)) {
                setState(() {
                  searchedFiles!.items.add(item);
                });
              }
            });
          },
        ),
      ),
      body: Center(child: defaultSearch()),
    );
  }
}
