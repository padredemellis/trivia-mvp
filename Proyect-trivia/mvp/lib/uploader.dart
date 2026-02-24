//import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class DataUploader extends StatefulWidget {
  const DataUploader({super.key});

  @override
  State<DataUploader> createState() => _DataUploaderState();
}

class _DataUploaderState extends State<DataUploader> {
  bool _uploading = false;
  String _status = "Listo para subir";

  // --- Aqui va el pool de preguntas ---
  Future<List<dynamic>> readJson(String filePath) async {
      final content = await rootBundle.loadString(filePath);
      return jsonDecode(content);
  }
  // -----------------------------------

  Future<void> uploadData() async {
    setState(() {
      _uploading = true;
      _status = "Subiendo...";
    });

    try {
      // 1. Convertimos el texto JSON a una lista de Dart
      final data = await readJson('lib/questions.json');
      final firestore = FirebaseFirestore.instance;

      // 2. Recorremos cada elemento y lo subimos
      for (var item in data) {
        await firestore
            .collection('questions') // Nombre de tu colección
            .doc(
              item['questionId'],
            ) // Usamos el ID del JSON como ID del documento
            .set(item);

        print("Subido: ${item['questionId']}");
      }

      setState(() {
        _status = "¡Éxito! Se subieron ${data.length} preguntas.";
      });
    } catch (e) {
      setState(() {
        _status = "Error: $e";
      });
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cargador de Datos")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            _uploading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: uploadData,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text("SUBIR JSON A FIREBASE"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(20),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
