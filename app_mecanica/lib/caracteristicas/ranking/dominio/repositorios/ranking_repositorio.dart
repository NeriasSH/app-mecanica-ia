import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/estudiante_ranking.dart';

abstract class RankingRepositorio {
  Future<Either<Falla, List<EstudianteRanking>>> obtenerRanking();
}
