import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LevelGenerator extends StatefulWidget {
  const LevelGenerator({super.key});

  @override
  State<LevelGenerator> createState() => _LevelGeneratorState();
}

class _LevelGeneratorState extends State<LevelGenerator> {
  bool _uploading = false;
  String _status = "Listo para generar 30 niveles con pools de 10 preguntas";

  
  final List<String> themes = [
    'Historia',
    'Actualidad',
    'Arte y Entretenimiento',
    'Ciencias Naturales',
    'Ciencias Sociales',
    'Deportes'
  ];

  Future<void> generateAndUploadLevels() async {
    setState(() {
      _uploading = true;
      _status = "1. Leyendo base de datos de preguntas...";
    });

    final firestore = FirebaseFirestore.instance;

    try {
      
      final questionsSnap = await firestore.collection('questions').get();
      final allDocs = questionsSnap.docs;

      if (allDocs.isEmpty) {
        throw "No hay preguntas en 'questions'. Súbelas primero.";
      }

      
      Map<String, List<String>> questionsByCategory = {};
      for (var theme in themes) {
        questionsByCategory[theme] = [];
      }

      for (var doc in allDocs) {
        final data = doc.data();
        String cat = data['category'] ?? 'Historia';
        if (questionsByCategory.containsKey(cat)) {
          questionsByCategory[cat]!.add(doc.id);
        }
      }

      setState(() {
        _status = "2. Clasificación completa. Subiendo nodos...";
      });

      final batch = firestore.batch();

      
      for (int i = 1; i <= 30; i++) {
        
        String currentTheme = themes[(i - 1) % themes.length];
        
        
        List<String> thematicPool = List.from(questionsByCategory[currentTheme] ?? []);
        thematicPool.shuffle();
        
        // --- CONFIGURACIÓN DE POOL (10) Y MUESTRA (3) ---
        List<String> selectedIds = thematicPool.take(10).toList();

        // Fallback: Si por alguna razón hay menos de 10 en la categoría, rellenar con azar
        if (selectedIds.length < 10) {
          var randomBackfill = (allDocs.toList()..shuffle())
              .take(10 - selectedIds.length)
              .map((d) => d.id);
          selectedIds.addAll(randomBackfill);
        }

        // Dificultad y recompensas según el progreso
        String difficulty = "easy";
        int coins = 100;
        if (i > 10) { difficulty = "medium"; coins = 200; }
        if (i > 20) { difficulty = "hard"; coins = 300; }

        DocumentReference docRef = firestore.collection('nodes').doc(i.toString());

        batch.set(docRef, {
          "nodeId": i,
          "title": "Nivel $i: $currentTheme",
          "description": "Reto de $currentTheme",
          "category": currentTheme,
          "difficulty": difficulty,
          "questionsToShow": 3,      
          "rewardCoins": coins,
          "poolQuestionIds": selectedIds, 
        });
      }

      // 4. Commit final
      await batch.commit();

      setState(() {
        _status = "¡Éxito! 30 niveles creados.\nCada uno con 10 preguntas de pool y 3 a responder.";
      });

    } catch (e) {
      setState(() => _status = "Error: $e");
      print("Error en LevelGenerator: $e");
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Master Level Generator"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.layers_outlined, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            _uploading
                ? const CircularProgressIndicator(color: Colors.amber)
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: generateAndUploadLevels,
                      icon: const Icon(Icons.settings_suggest),
                      label: const Text("RECONSTRUIR MAPA DE NIVELES"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}