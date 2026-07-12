import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../nucleo/errores/falla.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/repositorios/auth_repositorio.dart';
import '../fuentes_datos/auth_fuente_datos_remota.dart';

class AuthRepositorioImpl implements AuthRepositorio {
  final AuthFuenteDatosRemota fuenteDatosRemota;

  const AuthRepositorioImpl(this.fuenteDatosRemota);

  @override
  Future<Either<Falla, Usuario>> autenticarUsuario({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final usuario = await fuenteDatosRemota.iniciarSesion(correo, contrasena);
      return Right(usuario);
    } on TimeoutException catch (_) {
      return const Left(TiempoAgotadoFalla());
    } on FirebaseAuthException catch (_) {
      return const Left(CredencialesInvalidasFalla());
    } on StateError catch (_) {
      return const Left(RolNoEncontradoFalla());
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<Either<Falla, Usuario>> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
    required RolUsuario rol,
  }) async {
    try {
      final usuario = await fuenteDatosRemota.registrarUsuario(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        rol: rol == RolUsuario.docente ? 'docente' : 'estudiante',
      );
      return Right(usuario);
    } on TimeoutException catch (_) {
      return const Left(TiempoAgotadoFalla());
    } on FirebaseAuthException catch (_) {
      return const Left(CredencialesInvalidasFalla());
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<void> cerrarSesion() => fuenteDatosRemota.cerrarSesion();

  @override
  Future<Either<Falla, Usuario>> obtenerPerfil(String uid) async {
    try {
      final usuario = await fuenteDatosRemota.obtenerPerfil(uid);
      return Right(usuario);
    } on TimeoutException catch (_) {
      return const Left(TiempoAgotadoFalla());
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<Either<Falla, void>> actualizarPerfil({
    required String uid,
    String? nombre,
    bool? sonidoActivado,
    int? nivel,
    int? puntos,
    int? puntosVida,
  }) async {
    try {
      await fuenteDatosRemota.actualizarPerfil(
        uid: uid, 
        nombre: nombre, 
        sonidoActivado: sonidoActivado,
        nivel: nivel,
        puntos: puntos,
        puntosVida: puntosVida,
      );
      return const Right(null);
    } on TimeoutException catch (_) {
      return const Left(TiempoAgotadoFalla());
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }
}
