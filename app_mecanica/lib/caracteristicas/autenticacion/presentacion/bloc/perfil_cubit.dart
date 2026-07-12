import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/autenticar_usuario_caso_uso.dart';
import '../../dominio/entidades/usuario.dart';

abstract class PerfilEstado extends Equatable {
  const PerfilEstado();
  @override
  List<Object?> get props => [];
}

class PerfilCargando extends PerfilEstado {}

class PerfilCargado extends PerfilEstado {
  final Usuario usuario;
  final bool guardando;
  const PerfilCargado(this.usuario, {this.guardando = false});
  @override
  List<Object?> get props => [usuario, guardando];
}

class PerfilActualizado extends PerfilEstado {
  final Usuario usuario;
  const PerfilActualizado(this.usuario);
  @override
  List<Object?> get props => [usuario];
}

class PerfilFallido extends PerfilEstado {
  final String mensaje;
  const PerfilFallido(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}

/// CUS-03, Gestionar Perfil.
class PerfilCubit extends Cubit<PerfilEstado> {
  final ObtenerPerfilCasoUso obtenerPerfilCasoUso;
  final ActualizarPerfilCasoUso actualizarPerfilCasoUso;
  final String uid;

  PerfilCubit({
    required this.obtenerPerfilCasoUso,
    required this.actualizarPerfilCasoUso,
    required this.uid,
  }) : super(PerfilCargando());

  Future<void> cargar() async {
    emit(PerfilCargando());
    final resultado = await obtenerPerfilCasoUso.execute(uid);
    resultado.fold(
      (falla) => emit(PerfilFallido(falla.mensaje)),
      (usuario) => emit(PerfilCargado(usuario)),
    );
  }

  Future<void> actualizarPerfil({
    String? nuevoNombre, 
    bool? sonidoActivado,
    int? nivel,
    int? puntos,
    int? puntosVida,
  }) async {
    final resultado = await actualizarPerfilCasoUso.execute(
      uid: uid,
      nombre: nuevoNombre,
      sonidoActivado: sonidoActivado,
      nivel: nivel,
      puntos: puntos,
      puntosVida: puntosVida,
    );
    resultado.fold(
      (falla) => emit(PerfilFallido(falla.mensaje)),
      (_) => cargar(),
    );
  }
}
