import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataUploader extends StatefulWidget {
  const DataUploader({super.key});

  @override
  State<DataUploader> createState() => _DataUploaderState();
}

class _DataUploaderState extends State<DataUploader> {
  bool _uploading = false;
  String _status = "Listo para subir";

  // --- Aqui va el pool de preguntas ---
  final String rawJson = '''
[
  {
      "questionId": "q_001",
      "category": "Ciencias",
      "text": "¿Cuál es el lenguaje principal para desarrollar en Flutter?",
      "questionType": "multipleChoice",
      "correctAnswer": "Dart",
      "options": ["Java", "Kotlin", "Dart", "Swift"]
    },
    {
      "questionId": "q_002",
      "category": "Ciencias",
      "text": "¿Qué planeta es conocido como el Planeta Rojo?",
      "questionType": "multipleChoice",
      "correctAnswer": "Marte",
      "options": ["Júpiter", "Marte", "Saturno", "Venus"]
    },
    {
      "questionId": "q_003",
      "category": "Actualidad",
      "text": "¿En qué año se lanzó el primer iPhone?",
      "questionType": "multipleChoice",
      "correctAnswer": "2007",
      "options": ["2005", "2007", "2010", "1999"]
    },
    {
      "questionId": "q_004",
      "category": "Cultura",
      "text": "¿Quién pintó la Mona Lisa?",
      "questionType": "multipleChoice",
      "correctAnswer": "Da Vinci",
      "options": ["Picasso", "Van Gogh", "Da Vinci", "Dalí"]
    },
    {
      "questionId": "q_005",
      "category": "Ciencias",
      "text": "¿Cuál es el símbolo químico del agua?",
      "questionType": "multipleChoice",
      "correctAnswer": "H2O",
      "options": ["H2O", "O2", "CO2", "HO"]
    },
    {
      "questionId": "q_006",
      "category": "Cultura",
      "text": "¿Quién escribió 'Don Quijote de la Mancha'?",
      "questionType": "multipleChoice",
      "correctAnswer": "Cervantes",
      "options": ["García Márquez", "Cervantes", "Shakespeare", "Neruda"]
    },
    {
      "questionId": "q_007",
      "category": "Hobbies",
      "text": "¿Cuántos jugadores hay en un equipo de fútbol?",
      "questionType": "multipleChoice",
      "correctAnswer": "11",
      "options": ["9", "10", "11", "12"]
    },
    {
      "questionId": "q_008",
      "category": "Actualidad",
      "text": "¿Cuál es la capital de Francia?",
      "questionType": "multipleChoice",
      "correctAnswer": "París",
      "options": ["Madrid", "Londres", "Berlín", "París"]
    },
    {
      "questionId": "q_009",
      "category": "Ciencias",
      "text": "¿Qué gas respiramos principalmente?",
      "questionType": "multipleChoice",
      "correctAnswer": "Oxígeno",
      "options": ["Helio", "Oxígeno", "Carbono", "Hidrógeno"]
    },
    {
      "questionId": "q_010",
      "category": "Hobbies",
      "text": "¿Qué compañía creó a Mario Bros?",
      "questionType": "multipleChoice",
      "correctAnswer": "Nintendo",
      "options": ["Sega", "Sony", "Nintendo", "Microsoft"]
    },
    {
      "questionId": "q_011",
      "category": "Cultura",
      "text": "¿En qué continente está Egipto?",
      "questionType": "multipleChoice",
      "correctAnswer": "África",
      "options": ["Asia", "Europa", "África", "América"]
    },
    {
      "questionId": "q_012",
      "category": "Actualidad",
      "text": "¿Cuál es la moneda oficial de Japón?",
      "questionType": "multipleChoice",
      "correctAnswer": "Yen",
      "options": ["Dólar", "Euro", "Yen", "Won"]
    },
    {
      "questionId": "q_013",
      "category": "Hobbies",
      "text": "¿Cómo se llama el deporte que se juega con una raqueta y un volante?",
      "questionType": "multipleChoice",
      "correctAnswer": "Bádminton",
      "options": ["Tenis", "Pádel", "Ping Pong", "Bádminton"]
    },
    { "questionId": "q_014", "category": "Ciencias", "text": "¿Cuál es el hueso más largo del cuerpo humano?", "questionType": "multipleChoice", "correctAnswer": "Fémur", "options": ["Fémur", "Radio", "Tibia", "Húmero"] },
    { "questionId": "q_015", "category": "Ciencias", "text": "¿Qué elemento químico tiene el símbolo Au?", "questionType": "multipleChoice", "correctAnswer": "Oro", "options": ["Plata", "Cobre", "Oro", "Aluminio"] },
    { "questionId": "q_016", "category": "Ciencias", "text": "¿Cómo se llaman las células nerviosas?", "questionType": "multipleChoice", "correctAnswer": "Neuronas", "options": ["Neuronas", "Glóbulos", "Plaquetas", "Nefronas"] },
    { "questionId": "q_017", "category": "Ciencias", "text": "¿Qué parte de la planta realiza la fotosíntesis?", "questionType": "multipleChoice", "correctAnswer": "Hoja", "options": ["Raíz", "Tallo", "Hoja", "Flor"] },
    { "questionId": "q_018", "category": "Ciencias", "text": "¿Cuál es el animal más rápido del mundo?", "questionType": "multipleChoice", "correctAnswer": "Guepardo", "options": ["León", "Guepardo", "Águila", "Caballo"] },
    { "questionId": "q_019", "category": "Ciencias", "text": "¿Qué planeta tiene anillos visibles?", "questionType": "multipleChoice", "correctAnswer": "Saturno", "options": ["Marte", "Júpiter", "Saturno", "Neptuno"] },
    { "questionId": "q_020", "category": "Ciencias", "text": "¿Cuántos corazones tiene un pulpo?", "questionType": "multipleChoice", "correctAnswer": "3", "options": ["1", "2", "3", "4"] },
    { "questionId": "q_021", "category": "Ciencias", "text": "¿Cuál es el órgano más grande del cuerpo?", "questionType": "multipleChoice", "correctAnswer": "Piel", "options": ["Hígado", "Piel", "Cerebro", "Pulmón"] },

    { "questionId": "q_022", "category": "Cultura", "text": "¿Quién pintó 'La noche estrellada'?", "questionType": "multipleChoice", "correctAnswer": "Van Gogh", "options": ["Picasso", "Monet", "Van Gogh", "Dalí"] },
    { "questionId": "q_023", "category": "Cultura", "text": "¿En qué país se encuentran las pirámides de Teotihuacán?", "questionType": "multipleChoice", "correctAnswer": "México", "options": ["Egipto", "Perú", "México", "Guatemala"] },
    { "questionId": "q_024", "category": "Cultura", "text": "¿Cuál es el libro más vendido de la historia?", "questionType": "multipleChoice", "correctAnswer": "La Biblia", "options": ["Harry Potter", "El Quijote", "La Biblia", "El Principito"] },
    { "questionId": "q_025", "category": "Cultura", "text": "¿Quién fue el primer presidente de Estados Unidos?", "questionType": "multipleChoice", "correctAnswer": "Washington", "options": ["Lincoln", "Washington", "Jefferson", "Franklin"] },
    { "questionId": "q_026", "category": "Cultura", "text": "¿En qué año llegó el hombre a la Luna?", "questionType": "multipleChoice", "correctAnswer": "1969", "options": ["1950", "1969", "1975", "1980"] },
    { "questionId": "q_027", "category": "Cultura", "text": "¿Cuál es el idioma más hablado del mundo?", "questionType": "multipleChoice", "correctAnswer": "Inglés", "options": ["Español", "Chino", "Inglés", "Hindú"] },
    { "questionId": "q_028", "category": "Cultura", "text": "¿Dónde se originaron los Juegos Olímpicos?", "questionType": "multipleChoice", "correctAnswer": "Grecia", "options": ["Roma", "Grecia", "Francia", "Egipto"] },
    { "questionId": "q_029", "category": "Cultura", "text": "¿Quién escribió 'Romeo y Julieta'?", "questionType": "multipleChoice", "correctAnswer": "Shakespeare", "options": ["Dante", "Shakespeare", "Goethe", "Homer"] },

    { "questionId": "q_030", "category": "Actualidad", "text": "¿Quién fundó Microsoft?", "questionType": "multipleChoice", "correctAnswer": "Bill Gates", "options": ["Steve Jobs", "Elon Musk", "Bill Gates", "Jeff Bezos"] },
    { "questionId": "q_031", "category": "Actualidad", "text": "¿Cuál es la red social del pajarito azul (antes de X)?", "questionType": "multipleChoice", "correctAnswer": "Twitter", "options": ["Facebook", "Instagram", "Twitter", "Snapchat"] },
    { "questionId": "q_032", "category": "Actualidad", "text": "¿Qué moneda se usa en el Reino Unido?", "questionType": "multipleChoice", "correctAnswer": "Libra", "options": ["Euro", "Dólar", "Libra", "Franco"] },
    { "questionId": "q_033", "category": "Actualidad", "text": "¿Quién es el creador de Facebook?", "questionType": "multipleChoice", "correctAnswer": "Zuckerberg", "options": ["Gates", "Zuckerberg", "Musk", "Page"] },
    { "questionId": "q_034", "category": "Actualidad", "text": "¿Cuál es la empresa más valiosa del mundo (aprox)?", "questionType": "multipleChoice", "correctAnswer": "Apple", "options": ["Amazon", "Google", "Apple", "Tesla"] },
    { "questionId": "q_035", "category": "Actualidad", "text": "¿En qué año comenzó la pandemia de COVID-19?", "questionType": "multipleChoice", "correctAnswer": "2019", "options": ["2018", "2019", "2020", "2021"] },
    { "questionId": "q_036", "category": "Actualidad", "text": "¿Qué país ganó el mundial de fútbol 2022?", "questionType": "multipleChoice", "correctAnswer": "Argentina", "options": ["Francia", "Brasil", "Argentina", "Alemania"] },
    { "questionId": "q_037", "category": "Actualidad", "text": "¿Quién compró Twitter en 2022?", "questionType": "multipleChoice", "correctAnswer": "Elon Musk", "options": ["Jeff Bezos", "Bill Gates", "Elon Musk", "Warren Buffett"] },

    { "questionId": "q_038", "category": "Hobbies", "text": "¿Cuántas piezas tiene un ajedrez?", "questionType": "multipleChoice", "correctAnswer": "32", "options": ["30", "32", "36", "40"] },
    { "questionId": "q_039", "category": "Hobbies", "text": "¿Qué instrumento tiene 88 teclas?", "questionType": "multipleChoice", "correctAnswer": "Piano", "options": ["Guitarra", "Piano", "Órgano", "Violín"] },
    { "questionId": "q_040", "category": "Hobbies", "text": "¿Cuál es el deporte rey en Estados Unidos?", "questionType": "multipleChoice", "correctAnswer": "Fútbol Americano", "options": ["Béisbol", "Baloncesto", "Fútbol", "Fútbol Americano"] },
    { "questionId": "q_041", "category": "Hobbies", "text": "¿Cómo se llama el protagonista de Zelda?", "questionType": "multipleChoice", "correctAnswer": "Link", "options": ["Zelda", "Link", "Ganon", "Mario"] },
    { "questionId": "q_042", "category": "Hobbies", "text": "¿En qué deporte se usa un 'puck'?", "questionType": "multipleChoice", "correctAnswer": "Hockey", "options": ["Golf", "Tenis", "Hockey", "Curling"] },
    { "questionId": "q_043", "category": "Hobbies", "text": "¿Qué banda británica cantaba 'Yellow Submarine'?", "questionType": "multipleChoice", "correctAnswer": "The Beatles", "options": ["Queen", "Rolling Stones", "The Beatles", "Pink Floyd"] },
    { "questionId": "q_044", "category": "Hobbies", "text": "¿Qué arte marcial viene de Corea?", "questionType": "multipleChoice", "correctAnswer": "Taekwondo", "options": ["Karate", "Judo", "Taekwondo", "Kung Fu"] },
    { "questionId": "q_045", "category": "Hobbies", "text": "¿Cuál es el videojuego más vendido de la historia?", "questionType": "multipleChoice", "correctAnswer": "Minecraft", "options": ["Tetris", "GTA V", "Minecraft", "Fortnite"] }
]
  ''';
  // -----------------------------------

  Future<void> uploadData() async {
    setState(() {
      _uploading = true;
      _status = "Subiendo...";
    });

    try {
      // 1. Convertimos el texto JSON a una lista de Dart
      List<dynamic> data = jsonDecode(rawJson);
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
