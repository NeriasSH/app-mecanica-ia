import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/obtener_ranking_caso_uso.dart';
import '../../dominio/entidades/estudiante_ranking.dart';

abstract class RankingEstado extends Equatable {
  const RankingEstado();
  @override
  List<Object?> get props => [];
}

class RankingCargando extends RankingEstado {}

class RankingCargado extends RankingEstado {
  final List<EstudianteRanking> lista;
  const RankingCargado(this.lista);
  @override
  List<Object?> get props => [lista];
}

class RankingFallido extends RankingEstado {
  final String mensaje;
  const RankingFallido(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}

/// CUS-09, Consultar Ranking.
class RankingCubit extends Cubit<RankingEstado> {
  final ObtenerRankingCasoUso obtenerRankingCasoUso;

  RankingCubit(this.obtenerRankingCasoUso) : super(RankingCargando());

  Future<void> cargar() async {
    emit(RankingCargando());
    final resultado = await obtenerRankingCasoUso.execute();
    resultado.fold(
      (falla) => emit(RankingFallido(falla.mensaje)),
      (lista) => emit(RankingCargado(lista)),
    );
  }
}
