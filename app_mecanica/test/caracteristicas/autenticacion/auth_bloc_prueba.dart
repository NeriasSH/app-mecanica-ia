import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_flutter/nucleo/errores/falla.dart';
import 'package:proyecto_flutter/caracteristicas/autenticacion/dominio/entidades/usuario.dart';
import 'package:proyecto_flutter/caracteristicas/autenticacion/dominio/repositorios/auth_repositorio.dart';
import 'package:proyecto_flutter/caracteristicas/autenticacion/dominio/casos_uso/autenticar_usuario_caso_uso.dart';
import 'package:proyecto_flutter/caracteristicas/autenticacion/presentacion/bloc/auth_bloc.dart';
import 'package:proyecto_flutter/caracteristicas/autenticacion/presentacion/bloc/auth_evento.dart';
import 'package:proyecto_flutter/caracteristicas/autenticacion/presentacion/bloc/auth_estado.dart';

class _AuthRepositorioFalso implements AuthRepositorio {
  final bool credencialesValidas;
  _AuthRepositorioFalso({required this.credencialesValidas});

  @override
  Future<Either<Falla, Usuario>> autenticarUsuario({
    required String correo,
    required String contrasena,
  }) async {
    if (!credencialesValidas) return const Left(CredencialesInvalidasFalla());
    return Right(Usuario(
      uid: 'uid-123',
      nombre: 'Estudiante de prueba',
      correo: correo,
      rol: RolUsuario.estudiante,
    ));
  }

  @override
  Future<Either<Falla, Usuario>> registrarUsuario({
    required String nombre,
    required String correo,
    required String contrasena,
    required RolUsuario rol,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> cerrarSesion() async {}

  @override
  Future<Either<Falla, Usuario>> obtenerPerfil(String uid) async {
    return Right(Usuario(
      uid: uid,
      nombre: 'Estudiante de prueba',
      correo: 'test@sanmiguel.edu.pe',
      rol: RolUsuario.estudiante,
    ));
  }

  @override
  Future<Either<Falla, void>> actualizarPerfil({
    required String uid,
    required String nombre,
  }) async =>
      const Right(null);
}

void main() {
  group('AuthBloc - CUS-02 Autenticar Usuario', () {
    blocTest<AuthBloc, AuthEstado>(
      'emite [AuthCargando, AuthExitoso] cuando las credenciales son válidas',
      build: () => AuthBloc(
        autenticarUsuarioCasoUso: AutenticarUsuarioCasoUso(
          _AuthRepositorioFalso(credencialesValidas: true),
        ),
        registrarUsuarioCasoUso: RegistrarUsuarioCasoUso(
          _AuthRepositorioFalso(credencialesValidas: true),
        ),
        cerrarSesionCasoUso: CerrarSesionCasoUso(
          _AuthRepositorioFalso(credencialesValidas: true),
        ),
      ),
      act: (bloc) => bloc.add(
        const LoginSolicitado(
            correo: 'test@sanmiguel.edu.pe', contrasena: '123456'),
      ),
      expect: () => [isA<AuthCargando>(), isA<AuthExitoso>()],
    );

    blocTest<AuthBloc, AuthEstado>(
      'emite [AuthCargando, AuthFallido] cuando las credenciales son inválidas',
      build: () => AuthBloc(
        autenticarUsuarioCasoUso: AutenticarUsuarioCasoUso(
          _AuthRepositorioFalso(credencialesValidas: false),
        ),
        registrarUsuarioCasoUso: RegistrarUsuarioCasoUso(
          _AuthRepositorioFalso(credencialesValidas: false),
        ),
        cerrarSesionCasoUso: CerrarSesionCasoUso(
          _AuthRepositorioFalso(credencialesValidas: false),
        ),
      ),
      act: (bloc) => bloc.add(
        const LoginSolicitado(
            correo: 'test@sanmiguel.edu.pe', contrasena: 'incorrecta'),
      ),
      expect: () => [isA<AuthCargando>(), isA<AuthFallido>()],
    );
  });
}
