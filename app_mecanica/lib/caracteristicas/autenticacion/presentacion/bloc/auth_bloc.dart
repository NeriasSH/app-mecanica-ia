import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/autenticar_usuario_caso_uso.dart';
import 'auth_evento.dart';
import 'auth_estado.dart';

class AuthBloc extends Bloc<AuthEvento, AuthEstado> {
  final AutenticarUsuarioCasoUso autenticarUsuarioCasoUso;
  final RegistrarUsuarioCasoUso registrarUsuarioCasoUso;
  final CerrarSesionCasoUso cerrarSesionCasoUso;

  AuthBloc({
    required this.autenticarUsuarioCasoUso,
    required this.registrarUsuarioCasoUso,
    required this.cerrarSesionCasoUso,
  }) : super(AuthInicial()) {
    on<LoginSolicitado>(_alIniciarSesion);
    on<RegistroSolicitado>(_alRegistrar);
    on<CerrarSesionSolicitado>(_alCerrarSesion);
  }

  Future<void> _alIniciarSesion(
    LoginSolicitado evento,
    Emitter<AuthEstado> emit,
  ) async {
    emit(AuthCargando());
    final resultado = await autenticarUsuarioCasoUso.execute(
      correo: evento.correo,
      contrasena: evento.contrasena,
    );
    resultado.fold(
      (falla) => emit(AuthFallido(falla.mensaje)),
      (usuario) => emit(AuthExitoso(usuario)),
    );
  }

  Future<void> _alRegistrar(
    RegistroSolicitado evento,
    Emitter<AuthEstado> emit,
  ) async {
    emit(AuthCargando());
    final resultado = await registrarUsuarioCasoUso.execute(
      nombre: evento.nombre,
      correo: evento.correo,
      contrasena: evento.contrasena,
      rol: evento.rol,
    );
    resultado.fold(
      (falla) => emit(AuthFallido(falla.mensaje)),
      (usuario) => emit(AuthExitoso(usuario)),
    );
  }

  Future<void> _alCerrarSesion(
    CerrarSesionSolicitado evento,
    Emitter<AuthEstado> emit,
  ) async {
    await cerrarSesionCasoUso.execute();
    emit(AuthInicial());
  }
}
