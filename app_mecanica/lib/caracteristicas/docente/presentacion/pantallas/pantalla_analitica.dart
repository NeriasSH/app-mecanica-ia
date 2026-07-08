import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/analitica_cubit.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';

class PantallaAnalitica extends StatefulWidget {
  const PantallaAnalitica({super.key});

  @override
  State<PantallaAnalitica> createState() => _PantallaAnaliticaState();
}

class _PantallaAnaliticaState extends State<PantallaAnalitica> {
  @override
  void initState() {
    super.initState();
    context.read<AnaliticaCubit>().cargar();
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Analítica de desempeño'),
        actions: const [BotonCerrarSesion()],
      ),
      body: BlocBuilder<AnaliticaCubit, AnaliticaEstado>(
        builder: (context, state) {
          if (state is AnaliticaCargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AnaliticaFallida) {
            return Center(child: Text(state.mensaje));
          }

          final resumen = (state as AnaliticaCargada).resumen;

          return RefreshIndicator(
            onRefresh: () => context.read<AnaliticaCubit>().cargar(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resumen general',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Total de estudiantes: ${resumen.totalEstudiantes}'),
                        Text(
                          'Aciertos promedio: '
                          '${resumen.porcentajeAciertosPromedio.toStringAsFixed(1)}%',
                        ),
                        const SizedBox(height: 8),
                        ...resumen.distribucionPorNivel.entries.map(
                          (e) => Text('${e.key}: ${e.value} estudiantes'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Detalle por estudiante',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...resumen.detallePorEstudiante.map(
                  (e) => Card(
                    child: ListTile(
                      title: Text(e.nombreEstudiante),
                      subtitle: Text('Nivel de comprensión: ${e.nivelComprensionActual}'),
                      trailing: Text('${e.puntosTotales} pts'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}
