import 'package:flutter/material.dart';
import 'package:Proyect-trivia/mvp/pages/home.dart';
import 'package:Proyect-trivia/mvp/pages/map.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/map': (context) => MapPage(),
      },
    )); // MaterialApp
