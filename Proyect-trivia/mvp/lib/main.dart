import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'presentation/controllers/game_orchestrator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GameOrchestrator(), 
    ),
  );
}