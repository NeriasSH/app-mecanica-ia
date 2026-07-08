import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/analitica.dart';

abstract class DocenteRepositorio {
  Future<Either<Falla, void>> cargarPregunta(Pregunta pregunta);

  Future<Either<Falla, void>> actualizarPregunta(Pregunta pregunta);

  Future<Either<Falla, void>> eliminarPregunta(String preguntaId);

  Future<Either<Falla, List<Pregunta>>> listarPreguntas(
      {NivelDificultad? dificultad});

  Future<Either<Falla, ResumenAnalitica>> obtenerAnalitica();

  /// Carga en lote un set fijo de preguntas de ejemplo, útil para
  /// pruebas rápidas sin tener que registrar cada una manualmente.
  Future<Either<Falla, void>> cargarPreguntasDeEjemplo();
}
