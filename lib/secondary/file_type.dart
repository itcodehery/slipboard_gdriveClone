import 'package:flutter/material.dart';

enum FileType {
  docx,
  doc,
  pdf,
  ppt,
  xlsx,
}

final Map<FileType, Color> fileColors = {
  FileType.doc: Colors.blue.shade200,
  FileType.docx: Colors.blue.shade200,
  FileType.pdf: Colors.red.shade200,
  FileType.ppt: Colors.orange.shade200,
  FileType.xlsx: Colors.greenAccent.shade100
};
