import 'package:equatable/equatable.dart';

abstract class LearningEvento extends Equatable {
  const LearningEvento();
  @override
  List<Object?> get props => [];
}

/// CUS-05, paso 1-2: inicia el desafío para un tema y dificultad dados.
class DesafioIniciado extends LearningEvento {
  final String tema;
  final String dificultad;
  const DesafioIniciado({required this.tema, required this.dificultad});
  @override
  List<Object?> get props => [tema, dificultad];
}

/// CUS-05, paso 4-6: el estudiante selecciona una alternativa. Si es
/// incorrecta, la UI vuelve a emitir este evento incrementando
/// "intentos" en la siguiente selección para la misma pregunta.
class RespuestaEnviada extends LearningEvento {
  final int indiceSeleccionado;
  final double tiempoSegundos;
  final int intentos;

  const RespuestaEnviada({
    required this.indiceSeleccionado,
    required this.tiempoSegundos,
    required this.intentos,
  });

  @override
  List<Object?> get props => [indiceSeleccionado, tiempoSegundos, intentos];
}

class SiguientePreguntaSolicitada extends LearningEvento {}
