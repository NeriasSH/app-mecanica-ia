import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/usuario.dart';
import '../repositorios/auth_repositorio.dart';

class AutenticarUsuarioCasoUso {
  final AuthRepositorio repositorio;
  const AutenticarUsuarioCasoUso(this.repositorio);

  Future<Either<Falla, Usuario>> execute({
    required String correo,
    required String contrasena,
  }) {
    return repositorio.autenticarUsuario(correo: correo, contrasena: contrasena);
  }
}

class RegistrarUsuarioCasoUso {
  final AuthRepositorio repositorio;
  const RegistrarUsuarioCasoUso(this.repositorio);

  Future<Either<Falla, Usuario>> execute({
    required String nombre,
    required String correo,
    required String contrasena,
    required RolUsuario rol,
  }) {
    return repositorio.registrarUsuario(
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
      rol: rol,
    );
  }
}

class CerrarSesionCasoUso {
  final AuthRepositorio repositorio;
  const CerrarSesionCasoUso(this.repositorio);

  Future<void> execute() => repositorio.cerrarSesion();
}

/// CUS-03, Gestionar Perfil.
class ObtenerPerfilCasoUso {
  final AuthRepositorio repositorio;
  const ObtenerPerfilCasoUso(this.repositorio);

  Future<Either<Falla, Usuario>> execute(String uid) {
    return repositorio.obtenerPerfil(uid);
  }
}

class ActualizarPerfilCasoUso {
  final AuthRepositorio repositorio;
  const ActualizarPerfilCasoUso(this.repositorio);

  Future<Either<Falla, void>> execute({
    required String uid,
    required String nombre,
  }) {
    return repositorio.actualizarPerfil(uid: uid, nombre: nombre);
  }
}
