import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../../dominio/entidades/desafio.dart';
import '../../dominio/repositorios/desafio_repositorio.dart';
import '../fuentes_datos/desafio_fuente_datos_remota.dart';

class DesafioRepositorioImpl implements DesafioRepositorio {
  final DesafioFuenteDatosRemota fuenteDatosRemota;

  const DesafioRepositorioImpl(this.fuenteDatosRemota);

  @override
  Future<Either<Falla, List<Pregunta>>> obtenerPreguntas({
    required String tema,
    required NivelDificultad dificultad,
  }) async {
    try {
      final preguntas = await fuenteDatosRemota.obtenerPreguntas(
        tema: tema,
        dificultad: dificultad,
      );
      return Right(preguntas);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<Either<Falla, void>> guardarResultado({
    required String uidEstudiante,
    required String desafioId,
    required Resultado resultado,
  }) async {
    try {
      await fuenteDatosRemota.guardarResultado(
        uidEstudiante: uidEstudiante,
        desafioId: desafioId,
        resultado: resultado,
      );
      return const Right(null);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }
}
