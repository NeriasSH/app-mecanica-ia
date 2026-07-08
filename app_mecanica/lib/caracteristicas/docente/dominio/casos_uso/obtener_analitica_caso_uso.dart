import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/analitica.dart';
import '../repositorios/docente_repositorio.dart';

/// Corresponde a CUS-0X "Ver Analítica de Desempeño": agrega los
/// resultados de todos los estudiantes para que el docente identifique
/// quién necesita refuerzo.
class ObtenerAnaliticaCasoUso {
  final DocenteRepositorio repositorio;
  const ObtenerAnaliticaCasoUso(this.repositorio);

  Future<Either<Falla, ResumenAnalitica>> execute() {
    return repositorio.obtenerAnalitica();
  }
}
