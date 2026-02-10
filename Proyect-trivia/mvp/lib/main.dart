import 'package:flutter/material.dart';
import 'package:mvp/pages/home.dart';
import 'package:mvp/pages/map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // set up Flutter Engine

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // intialize Database
  
  runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {'/home': (context) => Home(), '/map': (context) => HomePage()},
  ),
); // MaterialApp
}
