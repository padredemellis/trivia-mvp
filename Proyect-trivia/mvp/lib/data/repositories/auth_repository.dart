import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repositorio encargado de gestionar la autenticación del jugador.
///
/// Abstrae la lógica de inicio de sesión con proveedores externos (Google)
/// y asegura que los datos del usuario se sincronicen correctamente con
/// la colección de usuarios en Firestore.
class AuthRepository {
  /// Instancia de FirebaseAuth para manejar la sesión en el backend.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Instancia de GoogleSignIn para lanzar el flujo interactivo de Google.
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Instancia de Firestore para persistir los datos del jugador.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Inicia el flujo de autenticación con Google.
  ///
  /// Despliega el modal nativo para que el jugador elija su cuenta de Google.
  /// Luego, obtiene las credenciales, inicia sesión en Firebase Auth y
  /// verifica si es necesario crear un documento nuevo en Firestore.
  ///
  /// Retorna un [UserCredential] si el proceso es exitoso, o [null] si el
  /// jugador cancela el flujo o si ocurre un error.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // El usuario cerró el modal de inicio de sesión
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      await _saveUserToFirestore(userCredential.user);

      return userCredential;
    } catch (e) {
      print("Error en AuthRepository.signInWithGoogle: $e");
      return null;
    }
  }

  /// Guarda o inicializa los datos del jugador en la base de datos.
  ///
  /// Busca si el usuario ya existe en la colección `Users`. Si es la primera
  /// vez que inicia sesión (el documento no existe), crea un perfil base con
  /// puntaje cero y progreso vacío.
  Future<void> _saveUserToFirestore(User? user) async {
    if (user != null) {
      final userRef = _firestore.collection('Users').doc(user.uid);
      final snapshot = await userRef.get();

      if (!snapshot.exists) {
        await userRef.set({
          'id': user.uid,
          'name': user.displayName ?? 'Jugador',
          'email': user.email,
          'score': 0,
          'progress': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  /// Cierra la sesión activa del jugador.
  ///
  /// Desconecta tanto la cuenta de Google en el dispositivo como la sesión
  /// de Firebase Auth, obligando a pedir credenciales en el próximo ingreso.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error en AuthRepository.signOut: $e");
      rethrow;
    }
  }
}

