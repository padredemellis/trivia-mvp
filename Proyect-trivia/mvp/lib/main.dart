import 'package:flutter/material.dart';
import 'package:mvp/pages/home.dart';
import 'package:mvp/pages/map.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/map': (context) => HomePage(),
      },
    )); // MaterialApp
