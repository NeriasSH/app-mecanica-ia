import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../../dominio/entidades/estudiante_ranking.dart';
import '../../dominio/repositorios/ranking_repositorio.dart';
import '../fuentes_datos/ranking_fuente_datos_remota.dart';

class RankingRepositorioImpl implements RankingRepositorio {
  final RankingFuenteDatosRemota fuenteDatosRemota;
  const RankingRepositorioImpl(this.fuenteDatosRemota);

  @override
  Future<Either<Falla, List<EstudianteRanking>>> obtenerRanking() async {
    try {
      final ranking = await fuenteDatosRemota.obtenerRanking();
      return Right(ranking);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }
}
