import 'package:flutter/material.dart';

enum Subjects { cpp, discreteStructures, webTech, holisticDev }

Map<Subjects, Color> subjectColorMap = {
  Subjects.cpp: Colors.redAccent.shade100,
  Subjects.discreteStructures: Colors.blueAccent.shade100,
  Subjects.webTech: Colors.greenAccent.shade100,
  Subjects.holisticDev: Colors.yellowAccent.shade100
};
