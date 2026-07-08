import '../../dominio/entidades/desafio.dart';

class PreguntaModelo extends Pregunta {
  const PreguntaModelo({
    required super.id,
    required super.enunciado,
    required super.tema,
    required super.alternativas,
    required super.indiceRespuestaCorrecta,
    required super.dificultad,
  });

  factory PreguntaModelo.fromFirestore(String id, Map<String, dynamic> data) {
    return PreguntaModelo(
      id: id,
      enunciado: data['enunciado'] as String? ?? '',
      tema: data['tema'] as String? ?? '',
      alternativas: List<String>.from(data['alternativas'] as List? ?? []),
      indiceRespuestaCorrecta: data['respuestaCorrecta'] as int? ?? 0,
      dificultad: dificultadDesdeTexto(data['dificultad'] as String? ?? 'basico'),
    );
  }

  static NivelDificultad dificultadDesdeTexto(String texto) {
    switch (texto) {
      case 'intermedio':
        return NivelDificultad.intermedio;
      case 'avanzado':
        return NivelDificultad.avanzado;
      default:
        return NivelDificultad.basico;
    }
  }

  static String dificultadATexto(NivelDificultad nivel) {
    switch (nivel) {
      case NivelDificultad.basico:
        return 'basico';
      case NivelDificultad.intermedio:
        return 'intermedio';
      case NivelDificultad.avanzado:
        return 'avanzado';
    }
  }
}
