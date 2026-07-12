import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/casos_uso/motor_adaptativo.dart';
import '../bloc/learning_bloc.dart';
import '../bloc/learning_evento.dart';
import '../bloc/learning_estado.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';
import '../../../../nucleo/constantes/rutas_app.dart';
import '../../../../nucleo/utilidades/servicio_audio.dart';
import '../../../autenticacion/presentacion/bloc/perfil_cubit.dart';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                // Se equivocó
                final perfilCubit = context.read<PerfilCubit>();
                if (perfilCubit.state is PerfilCargado || perfilCubit.state is PerfilActualizado) {
                  final usuario = perfilCubit.state is PerfilCargado 
                      ? (perfilCubit.state as PerfilCargado).usuario 
                      : (perfilCubit.state as PerfilActualizado).usuario;
                  
                  if (usuario.sonidoActivado) ServicioAudio().reproducirPerderVida();

                  final nuevasVidas = (usuario.puntosVida - 1).clamp(0, 3);
                  perfilCubit.actualizarPerfil(puntosVida: nuevasVidas);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.favorite_border, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(nuevasVidas == 0 ? '¡Te quedaste sin vidas!' : '¡Inténtalo de nuevo! -1 vida'),
                        ],
                      ),
                      backgroundColor: Colors.deepOrangeAccent,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            } else if (state is RetroalimentacionMostrada) {
               // Respondió correctamente, subió a RetroalimentacionMostrada
                final perfilCubit = context.read<PerfilCubit>();
                if (perfilCubit.state is PerfilCargado || perfilCubit.state is PerfilActualizado) {
                  final usuario = perfilCubit.state is PerfilCargado 
                      ? (perfilCubit.state as PerfilCargado).usuario 
                      : (perfilCubit.state as PerfilActualizado).usuario;

                  if (usuario.sonidoActivado) ServicioAudio().reproducirPuntos();
                  
                  final nuevosPuntos = usuario.puntos + 10;
                  int nuevoNivel = usuario.nivel;
                  
                  if (nuevosPuntos >= usuario.nivel * 100) {
                     nuevoNivel++;
                     if (usuario.sonidoActivado) ServicioAudio().reproducirSubirNivel();
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('¡Felicidades! Subiste al Nivel $nuevoNivel'), backgroundColor: Colors.green),
                     );
                  }

                  perfilCubit.actualizarPerfil(puntos: nuevosPuntos, nivel: nuevoNivel);
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
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (indice * 100)),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: OutlinedButton(
                              onPressed: () => _responder(estadoCargado, indice),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(pregunta.alternativas[indice]),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
