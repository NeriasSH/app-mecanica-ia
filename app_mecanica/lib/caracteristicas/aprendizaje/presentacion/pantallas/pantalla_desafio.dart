import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/motor_adaptativo.dart';
import '../bloc/learning_bloc.dart';
import '../bloc/learning_evento.dart';
import '../bloc/learning_estado.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';
import '../../../../nucleo/constantes/rutas_app.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';

class PantallaDesafio extends StatefulWidget {
  final String tema;
  const PantallaDesafio({super.key, required this.tema});

  @override
  State<PantallaDesafio> createState() => _PantallaDesafioState();
}

class _PantallaDesafioState extends State<PantallaDesafio> {
  DateTime? _inicioPregunta;

  @override
  void initState() {
    super.initState();
    context.read<LearningBloc>().add(
          DesafioIniciado(tema: widget.tema, dificultad: 'basico'),
        );
  }

  void _responder(DesafioCargado estado, int indice) {
    final tiempo = _inicioPregunta == null
        ? 0.0
        : DateTime.now().difference(_inicioPregunta!).inMilliseconds / 1000;

    context.read<LearningBloc>().add(RespuestaEnviada(
          indiceSeleccionado: indice,
          tiempoSegundos: tiempo,
          intentos: estado.intentosPreguntaActual,
        ));
  }

  String _mensajeFlujo(FlujoPedagogico flujo) {
    switch (flujo) {
      case FlujoPedagogico.avanzarSiguienteTema:
        return '¡Buen dominio! Puedes avanzar al siguiente tema.';
      case FlujoPedagogico.repasoReforzado:
        return 'Bien, pero conviene repasar este tema.';
      case FlujoPedagogico.bloquearYRedirigirATeoria:
        return 'Necesitas reforzar la teoría antes de continuar.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Desafío: ${widget.tema}'),
          actions: const [BotonCerrarSesion()],
        ),
        body: BlocConsumer<LearningBloc, LearningEstado>(
          listener: (context, state) {
            if (state is DesafioCargado) {
              if (state.intentosPreguntaActual == 0) {
                _inicioPregunta = DateTime.now();
              } else if (state.intentosPreguntaActual > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Inténtalo de nuevo, astronauta!'),
                    backgroundColor: Colors.deepOrangeAccent,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
        builder: (context, state) {
          if (state is LearningCargando || state is LearningInicial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LearningFallido) {
            return Center(child: Text(state.mensaje));
          }
          if (state is DesafioFinalizado) {
            return Center(
              child: Text(
                '¡Desafío completado! (${state.totalPreguntas} preguntas)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
          if (state is RetroalimentacionMostrada) {
            final debeIrATeoria =
                state.flujo == FlujoPedagogico.bloquearYRedirigirATeoria;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nivel detectado: ${state.nivel.name}'),
                  const SizedBox(height: 8),
                  Text(_mensajeFlujo(state.flujo), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // CUS-07: si el MotorAdaptativo clasificó el nivel
                      // como "baja", se redirige a CUS-10 (Consultar
                      // Teoría) antes de continuar con la siguiente
                      // pregunta del desafío.
                      if (debeIrATeoria) {
                        await Navigator.of(context).pushNamed(RutasApp.teoria);
                      }
                      if (context.mounted) {
                        context
                            .read<LearningBloc>()
                            .add(SiguientePreguntaSolicitada());
                      }
                    },
                    child: Text(debeIrATeoria ? 'Ir a Teoría' : 'Continuar'),
                  ),
                ],
              ),
            );
          }

          final estadoCargado = state as DesafioCargado;
          final pregunta = estadoCargado.preguntaActual;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregunta ${estadoCargado.indicePreguntaActual + 1} de '
                  '${estadoCargado.desafio.preguntas.length}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Text(pregunta.enunciado, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24),
                ...List.generate(pregunta.alternativas.length, (indice) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      onPressed: () => _responder(estadoCargado, indice),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(pregunta.alternativas[indice]),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    ),
    );
  }
}
