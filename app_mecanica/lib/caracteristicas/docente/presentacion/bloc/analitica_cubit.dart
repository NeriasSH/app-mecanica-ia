import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/obtener_analitica_caso_uso.dart';
import '../../dominio/entidades/analitica.dart';

abstract class AnaliticaEstado extends Equatable {
  const AnaliticaEstado();
  @override
  List<Object?> get props => [];
}

class AnaliticaCargando extends AnaliticaEstado {}

class AnaliticaCargada extends AnaliticaEstado {
  final ResumenAnalitica resumen;
  const AnaliticaCargada(this.resumen);
  @override
  List<Object?> get props => [resumen];
}

class AnaliticaFallida extends AnaliticaEstado {
  final String mensaje;
  const AnaliticaFallida(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}

class AnaliticaCubit extends Cubit<AnaliticaEstado> {
  final ObtenerAnaliticaCasoUso obtenerAnaliticaCasoUso;

  AnaliticaCubit(this.obtenerAnaliticaCasoUso) : super(AnaliticaCargando());

  Future<void> cargar() async {
    emit(AnaliticaCargando());
    final resultado = await obtenerAnaliticaCasoUso.execute();
    resultado.fold(
      (falla) => emit(AnaliticaFallida(falla.mensaje)),
      (resumen) => emit(AnaliticaCargada(resumen)),
    );
  }
}
