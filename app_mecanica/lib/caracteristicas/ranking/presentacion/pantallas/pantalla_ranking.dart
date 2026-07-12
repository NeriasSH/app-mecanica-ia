import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ranking_cubit.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (indice * 100)),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(50 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: esEstudianteActual 
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                              : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.black,
                              child: Text('${item.posicion}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                            trailing: Text('${item.puntos} pts', style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
