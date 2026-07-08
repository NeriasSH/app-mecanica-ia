import 'package:equatable/equatable.dart';
import '../../dominio/casos_uso/motor_adaptativo.dart';
import '../../dominio/entidades/desafio.dart';

abstract class LearningEstado extends Equatable {
  const LearningEstado();
  @override
  List<Object?> get props => [];
}

class LearningInicial extends LearningEstado {}

class LearningCargando extends LearningEstado {}

class DesafioCargado extends LearningEstado {
  final Desafio desafio;
  final int indicePreguntaActual;
  final int intentosPreguntaActual;

  const DesafioCargado({
    required this.desafio,
    this.indicePreguntaActual = 0,
    this.intentosPreguntaActual = 0,
  });

  Pregunta get preguntaActual => desafio.preguntas[indicePreguntaActual];
  bool get esUltimaPregunta =>
      indicePreguntaActual == desafio.preguntas.length - 1;

  DesafioCargado copiarCon({int? indicePreguntaActual, int? intentosPreguntaActual}) {
    return DesafioCargado(
      desafio: desafio,
      indicePreguntaActual: indicePreguntaActual ?? this.indicePreguntaActual,
      intentosPreguntaActual: intentosPreguntaActual ?? this.intentosPreguntaActual,
    );
  }

  @override
  List<Object?> get props => [desafio, indicePreguntaActual, intentosPreguntaActual];
}

/// Se muestra tras CUS-06/CUS-07: incluye el nivel de comprensión
/// clasificado y el flujo pedagógico que la UI debe aplicar.
class RetroalimentacionMostrada extends LearningEstado {
  final DesafioCargado estadoDesafio;
  final NivelComprension nivel;
  final FlujoPedagogico flujo;

  const RetroalimentacionMostrada({
    required this.estadoDesafio,
    required this.nivel,
    required this.flujo,
  });

  @override
  List<Object?> get props => [estadoDesafio, nivel, flujo];
}

class DesafioFinalizado extends LearningEstado {
  final int totalPreguntas;
  const DesafioFinalizado({required this.totalPreguntas});
  @override
  List<Object?> get props => [totalPreguntas];
}

class LearningFallido extends LearningEstado {
  final String mensaje;
  const LearningFallido(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}
