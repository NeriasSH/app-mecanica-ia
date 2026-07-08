import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/evaluar_resultado_caso_uso.dart';
import '../../dominio/casos_uso/obtener_preguntas_caso_uso.dart';
import '../../dominio/entidades/desafio.dart';
import 'learning_evento.dart';
import 'learning_estado.dart';

/// Nombre alineado a la Figura 5.7 de tu capítulo (LearningBloc).
class LearningBloc extends Bloc<LearningEvento, LearningEstado> {
  final ObtenerPreguntasCasoUso obtenerPreguntasCasoUso;
  final EvaluarResultadoUseCase evaluarResultadoUseCase;
  final String uidEstudiante;

  LearningBloc({
    required this.obtenerPreguntasCasoUso,
    required this.evaluarResultadoUseCase,
    required this.uidEstudiante,
  }) : super(LearningInicial()) {
    on<DesafioIniciado>(_alIniciarDesafio);
    on<RespuestaEnviada>(_alEnviarRespuesta);
    on<SiguientePreguntaSolicitada>(_alSolicitarSiguientePregunta);
  }

  Future<void> _alIniciarDesafio(
    DesafioIniciado evento,
    Emitter<LearningEstado> emit,
  ) async {
    emit(LearningCargando());

    // CUS-05 paso 2: obtiene preguntas vía CUS-04 (<<include>>).
    final resultado = await obtenerPreguntasCasoUso.execute(
      tema: evento.tema,
      dificultad: NivelDificultad.basico,
    );

    resultado.fold(
      (falla) => emit(LearningFallido(falla.mensaje)),
      (preguntas) {
        if (preguntas.isEmpty) {
          // Evita el RangeError al acceder a preguntas[0]: el tema o la
          // dificultad no coincide con ninguna pregunta cargada por el
          // docente (CUS-11). Se informa en vez de fallar en tiempo de
          // ejecución.
          emit(LearningFallido(
            'No hay preguntas disponibles para "${evento.tema}" en nivel '
            'básico. Pide al docente que cargue preguntas con ese tema '
            'exacto en el Banco de Preguntas.',
          ));
          return;
        }
        emit(DesafioCargado(
          desafio: Desafio(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            preguntas: preguntas,
            tema: evento.tema,
          ),
        ));
      },
    );
  }

  Future<void> _alEnviarRespuesta(
    RespuestaEnviada evento,
    Emitter<LearningEstado> emit,
  ) async {
    final estadoActual = state;
    if (estadoActual is! DesafioCargado) return;

    final esCorrecta = evento.indiceSeleccionado ==
        estadoActual.preguntaActual.indiceRespuestaCorrecta;

    if (!esCorrecta) {
      // CUS-05 paso 4-5: registra el intento fallido y permanece en la
      // misma pregunta (la UI vuelve a pedir selección).
      emit(estadoActual.copiarCon(
        intentosPreguntaActual: estadoActual.intentosPreguntaActual + 1,
      ));
      return;
    }

    // CUS-05 paso 6: invoca Evaluar Resultado (<<include>> CUS-06).
    final resultado = await evaluarResultadoUseCase.execute(
      uidEstudiante: uidEstudiante,
      desafioId: estadoActual.desafio.id,
      preguntaId: estadoActual.preguntaActual.id,
      tiempoSegundos: evento.tiempoSegundos,
      intentos: evento.intentos + 1,
    );

    resultado.fold(
      (falla) => emit(LearningFallido(falla.mensaje)),
      (resultadoEvaluado) => emit(RetroalimentacionMostrada(
        estadoDesafio: estadoActual,
        nivel: resultadoEvaluado.resultado.nivel,
        flujo: resultadoEvaluado.flujo,
      )),
    );
  }

  void _alSolicitarSiguientePregunta(
    SiguientePreguntaSolicitada evento,
    Emitter<LearningEstado> emit,
  ) {
    final estadoActual = state;
    if (estadoActual is! RetroalimentacionMostrada) return;

    final desafioPrevio = estadoActual.estadoDesafio;

    if (desafioPrevio.esUltimaPregunta) {
      emit(DesafioFinalizado(
          totalPreguntas: desafioPrevio.desafio.preguntas.length));
      return;
    }

    emit(desafioPrevio.copiarCon(
      indicePreguntaActual: desafioPrevio.indicePreguntaActual + 1,
      intentosPreguntaActual: 0,
    ));
  }
}
