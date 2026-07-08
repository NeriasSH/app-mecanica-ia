import '../casos_uso/motor_adaptativo.dart';

enum NivelDificultad { basico, intermedio, avanzado }

class Pregunta {
  final String id;
  final String enunciado;
  final String tema;
  final List<String> alternativas;
  final int indiceRespuestaCorrecta;
  final NivelDificultad dificultad;

  const Pregunta({
    required this.id,
    required this.enunciado,
    required this.tema,
    required this.alternativas,
    required this.indiceRespuestaCorrecta,
    required this.dificultad,
  });
}

class Desafio {
  final String id;
  final List<Pregunta> preguntas;
  final String tema;

  const Desafio({
    required this.id,
    required this.preguntas,
    required this.tema,
  });
}

/// Corresponde a la subcolección desafios/{id}/resultados (Tabla 22).
/// tiempoSegundos e intentos son las variables de entrada que consume
/// MotorAdaptativo.predecirNivel(); nivel es la salida (CUS-06/CUS-07).
class Resultado {
  final String preguntaId;
  final double tiempoSegundos;
  final int intentos;
  final NivelComprension nivel;

  const Resultado({
    required this.preguntaId,
    required this.tiempoSegundos,
    required this.intentos,
    required this.nivel,
  });
}
