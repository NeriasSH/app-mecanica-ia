import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/desafio.dart';

abstract class DesafioRepositorio {
  /// Corresponde a CUS-04 Obtener Preguntas.
  Future<Either<Falla, List<Pregunta>>> obtenerPreguntas({
    required String tema,
    required NivelDificultad dificultad,
  });

  /// Corresponde a CUS-08 Registrar Progreso: persiste el resultado en
  /// desafios/{id}/resultados y actualiza progreso + ranking embebidos.
  Future<Either<Falla, void>> guardarResultado({
    required String uidEstudiante,
    required String desafioId,
    required Resultado resultado,
  });
}
