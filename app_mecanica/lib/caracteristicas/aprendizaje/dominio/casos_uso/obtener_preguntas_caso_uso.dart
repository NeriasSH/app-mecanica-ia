import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/desafio.dart';
import '../repositorios/desafio_repositorio.dart';

/// CUS-04, Obtener Preguntas (<<include>> de CUS-05).
class ObtenerPreguntasCasoUso {
  final DesafioRepositorio repositorio;
  const ObtenerPreguntasCasoUso(this.repositorio);

  Future<Either<Falla, List<Pregunta>>> execute({
    required String tema,
    required NivelDificultad dificultad,
  }) {
    return repositorio.obtenerPreguntas(tema: tema, dificultad: dificultad);
  }
}
