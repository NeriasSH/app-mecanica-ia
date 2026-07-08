import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/estudiante_ranking.dart';
import '../repositorios/ranking_repositorio.dart';

/// CUS-09, Consultar Ranking.
class ObtenerRankingCasoUso {
  final RankingRepositorio repositorio;
  const ObtenerRankingCasoUso(this.repositorio);

  Future<Either<Falla, List<EstudianteRanking>>> execute() {
    return repositorio.obtenerRanking();
  }
}
