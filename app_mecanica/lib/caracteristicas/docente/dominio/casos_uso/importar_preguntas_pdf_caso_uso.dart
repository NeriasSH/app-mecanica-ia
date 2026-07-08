import '../../../aprendizaje/dominio/entidades/desafio.dart';
import '../../../aprendizaje/datos/modelos/pregunta_modelo.dart';

/// Resultado de interpretar el PDF: preguntas listas para revisar y
/// guardar, más las líneas que no se pudieron interpretar (para que
/// el docente sepa qué corregir en el documento).
class ResultadoImportacionPdf {
  final List<Pregunta> preguntas;
  final List<String> lineasNoReconocidas;

  const ResultadoImportacionPdf({
    required this.preguntas,
    required this.lineasNoReconocidas,
  });
}

/// CUS-11 (extensión), Importar Preguntas desde PDF.
///
/// El docente debe seguir esta plantilla exacta en el PDF, una
/// pregunta tras otra:
///
///   TEMA: Leyes de Newton
///   DIFICULTAD: basico
///   1. ¿Cuál es la unidad de la fuerza en el Sistema Internacional?
///   a) Joule
///   b) Newton *
///   c) Watt
///   d) Pascal
///
/// Reglas:
/// - "TEMA:" y "DIFICULTAD:" aplican a todas las preguntas siguientes,
///   hasta que aparezca una nueva línea TEMA:/DIFICULTAD:.
/// - DIFICULTAD acepta: basico, intermedio, avanzado.
/// - Cada pregunta empieza con un número seguido de un punto.
/// - Cada alternativa empieza con una letra (a, b, c, d...) y paréntesis.
/// - La alternativa correcta se marca con un asterisco (*) al final.
class ImportarPreguntasPdfCasoUso {
  const ImportarPreguntasPdfCasoUso();

  ResultadoImportacionPdf execute(String textoPlano) {
    final lineas = textoPlano
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final regexTema = RegExp(r'^TEMA:\s*(.+)$', caseSensitive: false);
    final regexDificultad =
        RegExp(r'^DIFICULTAD:\s*(.+)$', caseSensitive: false);
    final regexPregunta = RegExp(r'^\d+[\.\)]\s*(.+)$');
    final regexAlternativa = RegExp(r'^[a-dA-D][\.\)]\s*(.+)$');

    String temaActual = '';
    NivelDificultad dificultadActual = NivelDificultad.basico;

    final preguntas = <Pregunta>[];
    final noReconocidas = <String>[];

    String? enunciadoActual;
    final alternativasActuales = <String>[];
    int indiceCorrectoActual = -1;

    void cerrarPreguntaActual() {
      if (enunciadoActual == null || alternativasActuales.isEmpty) return;
      preguntas.add(Pregunta(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            preguntas.length.toString(),
        enunciado: enunciadoActual!,
        tema: temaActual,
        alternativas: List.of(alternativasActuales),
        indiceRespuestaCorrecta:
            indiceCorrectoActual < 0 ? 0 : indiceCorrectoActual,
        dificultad: dificultadActual,
      ));
      enunciadoActual = null;
      alternativasActuales.clear();
      indiceCorrectoActual = -1;
    }

    for (final linea in lineas) {
      final matchTema = regexTema.firstMatch(linea);
      if (matchTema != null) {
        cerrarPreguntaActual();
        temaActual = matchTema.group(1)!.trim();
        continue;
      }

      final matchDificultad = regexDificultad.firstMatch(linea);
      if (matchDificultad != null) {
        dificultadActual = PreguntaModelo.dificultadDesdeTexto(
            matchDificultad.group(1)!.trim().toLowerCase());
        continue;
      }

      final matchPregunta = regexPregunta.firstMatch(linea);
      if (matchPregunta != null) {
        cerrarPreguntaActual();
        enunciadoActual = matchPregunta.group(1)!.trim();
        continue;
      }

      final matchAlternativa = regexAlternativa.firstMatch(linea);
      if (matchAlternativa != null && enunciadoActual != null) {
        var texto = matchAlternativa.group(1)!.trim();
        final esCorrecta = texto.endsWith('*');
        if (esCorrecta) {
          texto = texto.substring(0, texto.length - 1).trim();
          indiceCorrectoActual = alternativasActuales.length;
        }
        alternativasActuales.add(texto);
        continue;
      }

      // Ninguna regla coincidió: se reporta para que el docente revise
      // el PDF, en vez de fallar silenciosamente.
      noReconocidas.add(linea);
    }

    cerrarPreguntaActual();

    return ResultadoImportacionPdf(
      preguntas: preguntas,
      lineasNoReconocidas: noReconocidas,
    );
  }
}
