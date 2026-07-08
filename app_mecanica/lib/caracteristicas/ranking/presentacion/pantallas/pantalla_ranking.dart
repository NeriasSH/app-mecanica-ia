import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ranking_cubit.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';

/// CUS-09, Consultar Ranking.
class PantallaRanking extends StatefulWidget {
  final String? uidEstudianteActual;
  const PantallaRanking({super.key, this.uidEstudianteActual});

  @override
  State<PantallaRanking> createState() => _PantallaRankingState();
}

class _PantallaRankingState extends State<PantallaRanking> {
  @override
  void initState() {
    super.initState();
    context.read<RankingCubit>().cargar();
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ranking'),
          actions: const [BotonCerrarSesion()],
        ),
      body: BlocBuilder<RankingCubit, RankingEstado>(
        builder: (context, state) {
          if (state is RankingCargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RankingFallido) {
            return Center(child: Text(state.mensaje));
          }

          final lista = (state as RankingCargado).lista;

          if (lista.isEmpty) {
            return const Center(
              child: Text('Aún no hay estudiantes en el ranking.\n¡Resuelve tu primer desafío!',
                  textAlign: TextAlign.center),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<RankingCubit>().cargar(),
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, indice) {
                final item = lista[indice];
                final esEstudianteActual = item.uid == widget.uidEstudianteActual;
                return ListTile(
                  tileColor: esEstudianteActual
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  leading: CircleAvatar(child: Text('${item.posicion}')),
                  title: Text(item.nombre),
                  trailing: Text('${item.puntos} pts'),
                );
              },
            ),
          );
        },
      ),
    ));
  }
}
