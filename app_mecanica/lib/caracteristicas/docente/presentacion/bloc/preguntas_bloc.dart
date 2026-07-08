import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../aprendizaje/dominio/entidades/desafio.dart';
import '../../dominio/casos_uso/gestionar_preguntas_casos_uso.dart';

// --- Eventos ---
abstract class PreguntasEvento extends Equatable {
  const PreguntasEvento();
  @override
  List<Object?> get props => [];
}

class PreguntasSolicitadas extends PreguntasEvento {
  final NivelDificultad? nivel;
  const PreguntasSolicitadas({this.nivel});
  @override
  List<Object?> get props => [nivel];
}

class PreguntaGuardada extends PreguntasEvento {
  final Pregunta pregunta;
  final bool esEdicion;
  const PreguntaGuardada(this.pregunta, {required this.esEdicion});
  @override
  List<Object?> get props => [pregunta, esEdicion];
}

class PreguntaEliminada extends PreguntasEvento {
  final String preguntaId;
  const PreguntaEliminada(this.preguntaId);
  @override
  List<Object?> get props => [preguntaId];
}

class PreguntasDeEjemploSolicitadas extends PreguntasEvento {}

// --- Estados ---
abstract class PreguntasEstado extends Equatable {
  const PreguntasEstado();
  @override
  List<Object?> get props => [];
}

class PreguntasCargando extends PreguntasEstado {}

class PreguntasCargadas extends PreguntasEstado {
  final List<Pregunta> preguntas;
  const PreguntasCargadas(this.preguntas);
  @override
  List<Object?> get props => [preguntas];
}

class PreguntasFallidas extends PreguntasEstado {
  final String mensaje;
  const PreguntasFallidas(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}

// --- Bloc ---
class PreguntasBloc extends Bloc<PreguntasEvento, PreguntasEstado> {
  final CargarPreguntaCasoUso cargarPreguntaCasoUso;
  final ActualizarPreguntaCasoUso actualizarPreguntaCasoUso;
  final EliminarPreguntaCasoUso eliminarPreguntaCasoUso;
  final ListarPreguntasCasoUso listarPreguntasCasoUso;
  final CargarPreguntasDeEjemploCasoUso cargarPreguntasDeEjemploCasoUso;

  PreguntasBloc({
    required this.cargarPreguntaCasoUso,
    required this.actualizarPreguntaCasoUso,
    required this.eliminarPreguntaCasoUso,
    required this.listarPreguntasCasoUso,
    required this.cargarPreguntasDeEjemploCasoUso,
  }) : super(PreguntasCargando()) {
    on<PreguntasSolicitadas>(_alSolicitarPreguntas);
    on<PreguntaGuardada>(_alGuardarPregunta);
    on<PreguntaEliminada>(_alEliminarPregunta);
    on<PreguntasDeEjemploSolicitadas>(_alCargarPreguntasDeEjemplo);
  }

  Future<void> _alSolicitarPreguntas(
    PreguntasSolicitadas evento,
    Emitter<PreguntasEstado> emit,
  ) async {
    emit(PreguntasCargando());
    final resultado =
        await listarPreguntasCasoUso.execute(dificultad: evento.nivel);
    resultado.fold(
      (falla) => emit(PreguntasFallidas(falla.mensaje)),
      (preguntas) => emit(PreguntasCargadas(preguntas)),
    );
  }

  Future<void> _alGuardarPregunta(
    PreguntaGuardada evento,
    Emitter<PreguntasEstado> emit,
  ) async {
    final resultado = evento.esEdicion
        ? await actualizarPreguntaCasoUso.execute(evento.pregunta)
        : await cargarPreguntaCasoUso.execute(evento.pregunta);

    resultado.fold(
      (falla) => emit(PreguntasFallidas(falla.mensaje)),
      (_) => add(const PreguntasSolicitadas()),
    );
  }

  Future<void> _alEliminarPregunta(
    PreguntaEliminada evento,
    Emitter<PreguntasEstado> emit,
  ) async {
    final resultado = await eliminarPreguntaCasoUso.execute(evento.preguntaId);
    resultado.fold(
      (falla) => emit(PreguntasFallidas(falla.mensaje)),
      (_) => add(const PreguntasSolicitadas()),
    );
  }

  Future<void> _alCargarPreguntasDeEjemplo(
    PreguntasDeEjemploSolicitadas evento,
    Emitter<PreguntasEstado> emit,
  ) async {
    emit(PreguntasCargando());
    final resultado = await cargarPreguntasDeEjemploCasoUso.execute();
    resultado.fold(
      (falla) => emit(PreguntasFallidas(falla.mensaje)),
      (_) => add(const PreguntasSolicitadas()),
    );
  }
}
