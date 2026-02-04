import 'package:flutter/material.dart';
import 'mvp/pages/home.dart';
import 'mvp/pages/map.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/map': (context) => MapPage(),
      },
    )); // MaterialApp
