import 'package:flutter/material.dart';
import 'package:tu_app/pages/home.dart';
import 'package:tu_app/pages/map.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/map': (context) => HomePage(),
      },
    )); // MaterialApp
