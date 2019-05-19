import 'package:flutter/material.dart';
import './screens/homePage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQFLite',
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}