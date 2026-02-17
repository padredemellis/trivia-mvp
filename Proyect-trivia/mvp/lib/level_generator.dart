import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LevelGenerator extends StatefulWidget {
  const LevelGenerator({super.key});

  @override
  State<LevelGenerator> createState() => _LevelGeneratorState();
}

class _LevelGeneratorState extends State<LevelGenerator> {
  bool _uploading = false;
  String _status = "Listo para generar 30 niveles temáticos";

  // Temas que coinciden con las categorías de tus preguntas en el JSON
  final List<String> themes = ['Cultura', 'Ciencias', 'Actualidad', 'Hobbies'];

  Future<void> generateAndUploadLevels() async {
    setState(() {
      _uploading = true;
      _status = "1. Leyendo preguntas de Firebase...";
    });

    final firestore = FirebaseFirestore.instance;
    
    try {
      // 1. Descargamos TODAS las preguntas que subiste para clasificarlas
      final questionsSnap = await firestore.collection('questions').get();
      final allQuestions = questionsSnap.docs;

      if (allQuestions.isEmpty) {
        throw "No se encontraron preguntas en la colección 'questions'. Súbelas primero con el DataUploader.";
      }

      // 2. Organizamos los IDs de las preguntas en "bolsas" por categoría
      Map<String, List<String>> questionsByCategory = {
        'Cultura': [],
        'Ciencias': [],
        'Actualidad': [],
        'Hobbies': [],
      };

      for (var doc in allQuestions) {
        final data = doc.data();
        String cat = data['category'] ?? 'Cultura'; // Por defecto Cultura si no tiene
        
        if (questionsByCategory.containsKey(cat)) {
          questionsByCategory[cat]!.add(doc.id);
        }
      }

      setState(() {
        _status = "2. Clasificación lista. Subiendo niveles...";
      });

      final batch = firestore.batch();

      // 3. Generamos los 30 niveles con lógica de filtrado
      for (int i = 1; i <= 30; i++) {
        // Determinamos el tema del nivel según el orden del mapa (1:Cultura, 2:Ciencias...)
        String currentTheme = themes[(i - 1) % themes.length]; 
        
        // Obtenemos las preguntas que pertenecen SOLO a este tema
        List<String> thematicPool = List.from(questionsByCategory[currentTheme] ?? []);
        
        // Mezclamos las preguntas del tema para que no siempre salgan las mismas
        thematicPool.shuffle();
        
        // Tomamos hasta 4 preguntas para el pool de este nivel (el motor elegirá 2 al azar luego)
        List<String> selectedPoolIds = thematicPool.take(4).toList();

        // Si el pool temático está vacío (error de carga), usamos preguntas aleatorias como backup
        if (selectedPoolIds.isEmpty) {
          selectedPoolIds = (allQuestions..shuffle()).take(3).map((d) => d.id).toList();
        }

        // Configuración progresiva
        String difficulty = "easy";
        int coins = 100;
        if (i > 10) { difficulty = "medium"; coins = 200; }
        if (i > 20) { difficulty = "hard"; coins = 300; }

        DocumentReference docRef = firestore.collection('nodes').doc(i.toString());
        
        batch.set(docRef, {
          "nodeId": i,                 // int
          "title": currentTheme,       // string
          "description": "Desafío de $currentTheme",
          "difficulty": difficulty,
          "questionsToShow": 2,        // int (cuántas preguntas debe responder el usuario)
          "rewardCoins": coins,        // int
          "poolQuestionIds": selectedPoolIds, // array de strings (IDs de preguntas del tema)
        });
      }

      // 4. Ejecutar la subida masiva
      await batch.commit();

      setState(() {
        _status = "¡Éxito! 30 niveles creados.\nCada nivel tiene sus temas correctos.";
      });

    } catch (e) {
      setState(() {
        _status = "Error crítico: $e";
      });
      print(e);
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: const Text("Generador de Niveles Pro")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, size: 80, color: Colors.purpleAccent),
              const SizedBox(height: 30),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 40),
              _uploading
                  ? const CircularProgressIndicator(color: Colors.purpleAccent)
                  : ElevatedButton.icon(
                      onPressed: generateAndUploadLevels,
                      icon: const Icon(Icons.rocket_launch),
                      label: const Text("SINCRONIZAR 30 NIVELES TEMÁTICOS"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}