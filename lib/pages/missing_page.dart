import 'package:flutter/material.dart';

class MissingPage extends StatelessWidget {
  const MissingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/missing.png', width: 400, height: 400),
    );
  }
}
