import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modelos/usuario_modelo.dart';

/// Tiempo máximo de espera para cualquier llamada a Firebase. Sin esto,
/// una conexión inestable deja la operación "colgada" indefinidamente
/// (el círculo de carga gira para siempre), en vez de fallar rápido
/// con un mensaje claro para el usuario.
const _tiempoLimite = Duration(seconds: 15);

class AuthFuenteDatosRemota {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthFuenteDatosRemota({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UsuarioModelo> iniciarSesion(String correo, String contrasena) async {
    final credential = await _firebaseAuth
        .signInWithEmailAndPassword(email: correo, password: contrasena)
        .timeout(_tiempoLimite);

    final uid = credential.user!.uid;
    final doc = await _firestore
        .collection('usuarios')
        .doc(uid)
        .get()
        .timeout(_tiempoLimite);

    if (!doc.exists) {
      throw StateError(
          'El usuario autenticado no tiene documento en Firestore.');
    }

    return UsuarioModelo.fromFirestore(uid, doc.data()!);
  }

  Future<UsuarioModelo> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
  }) async {
    final credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: correo, password: contrasena)
        .timeout(_tiempoLimite);

    final uid = credential.user!.uid;
    final data = {
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'nivel': 1,
      'puntos': 0,
      'puntosVida': 3,
      'sonidoActivado': true,
      'fechaRegistro': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('usuarios')
        .doc(uid)
        .set(data)
        .timeout(_tiempoLimite);

    return UsuarioModelo.fromFirestore(uid, data);
  }

  Future<void> cerrarSesion() => _firebaseAuth.signOut();

  /// CUS-03, paso 2: consulta los datos actuales del usuario.
  Future<UsuarioModelo> obtenerPerfil(String uid) async {
    final doc = await _firestore
        .collection('usuarios')
        .doc(uid)
        .get()
        .timeout(_tiempoLimite);
    if (!doc.exists) {
      throw StateError('El usuario no tiene documento en Firestore.');
    }
    return UsuarioModelo.fromFirestore(uid, doc.data()!);
  }

  Future<void> actualizarPerfil({
    required String uid,
    String? nombre,
    bool? sonidoActivado,
    int? nivel,
    int? puntos,
    int? puntosVida,
  }) async {
    final Map<String, dynamic> data = {};
    if (nombre != null) data['nombre'] = nombre;
    if (sonidoActivado != null) data['sonidoActivado'] = sonidoActivado;
    if (nivel != null) data['nivel'] = nivel;
    if (puntos != null) data['puntos'] = puntos;
    if (puntosVida != null) data['puntosVida'] = puntosVida;
    
    if (data.isNotEmpty) {
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .update(data)
          .timeout(_tiempoLimite);
    }
  }
}
