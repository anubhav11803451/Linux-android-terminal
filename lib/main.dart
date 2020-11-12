import 'package:automatedlinuxterminal/copy.dart';
import 'package:automatedlinuxterminal/linux_terminal.dart';
import 'package:automatedlinuxterminal/login.dart';
import 'package:automatedlinuxterminal/terminal.dart';
//import 'package:automatedlinuxterminal/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
      //home: MyCLI2(),
      //home: MyDockerApp(),
    );
  }
}
