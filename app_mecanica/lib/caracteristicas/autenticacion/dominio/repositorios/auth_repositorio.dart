import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/usuario.dart';

abstract class AuthRepositorio {
  Future<Either<Falla, Usuario>> autenticarUsuario({
    required String correo,
    required String contrasena,
  });

  Future<Either<Falla, Usuario>> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
    required RolUsuario rol,
  });

  Future<void> cerrarSesion();

  /// CUS-03, Gestionar Perfil.
  Future<Either<Falla, Usuario>> obtenerPerfil(String uid);

  Future<Either<Falla, void>> actualizarPerfil({
    required String uid,
    required String nombre,
  });
}
