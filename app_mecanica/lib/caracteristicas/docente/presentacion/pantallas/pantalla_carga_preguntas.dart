import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../aprendizaje/dominio/entidades/desafio.dart';
import '../bloc/preguntas_bloc.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';
import 'pantalla_importar_pdf.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';

class PantallaCargaPreguntas extends StatefulWidget {
  const PantallaCargaPreguntas({super.key});

  @override
  State<PantallaCargaPreguntas> createState() => _PantallaCargaPreguntasState();
}

class _PantallaCargaPreguntasState extends State<PantallaCargaPreguntas> {
  @override
  void initState() {
    super.initState();
    context.read<PreguntasBloc>().add(const PreguntasSolicitadas());
  }

  void _abrirFormulario(BuildContext context, {Pregunta? preguntaExistente}) {
    final enunciadoController =
        TextEditingController(text: preguntaExistente?.enunciado ?? '');
    final temaController =
        TextEditingController(text: preguntaExistente?.tema ?? '');
    final alternativasController = TextEditingController(
      text: preguntaExistente?.alternativas.join(', ') ?? '',
    );
    final indiceController = TextEditingController(
      text: preguntaExistente?.indiceRespuestaCorrecta.toString() ?? '0',
    );
    NivelDificultad dificultadSeleccionada =
        preguntaExistente?.dificultad ?? NivelDificultad.basico;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      preguntaExistente == null
                          ? 'Nueva pregunta'
                          : 'Editar pregunta',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: enunciadoController,
                      decoration: const InputDecoration(labelText: 'Enunciado'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: temaController,
                      decoration: const InputDecoration(labelText: 'Tema'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: alternativasController,
                      decoration: const InputDecoration(
                        labelText: 'Alternativas (separadas por coma)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: indiceController,
                      decoration: const InputDecoration(
                        labelText: 'Índice de la respuesta correcta',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<NivelDificultad>(
                      initialValue: dificultadSeleccionada,
                      decoration:
                          const InputDecoration(labelText: 'Dificultad'),
                      items: NivelDificultad.values
                          .map((n) =>
                              DropdownMenuItem(value: n, child: Text(n.name)))
                          .toList(),
                      onChanged: (valor) =>
                          setModalState(() => dificultadSeleccionada = valor!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final pregunta = Pregunta(
                          id: preguntaExistente?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          enunciado: enunciadoController.text,
                          tema: temaController.text,
                          alternativas: alternativasController.text
                              .split(',')
                              .map((o) => o.trim())
                              .where((o) => o.isNotEmpty)
                              .toList(),
                          indiceRespuestaCorrecta:
                              int.tryParse(indiceController.text) ?? 0,
                          dificultad: dificultadSeleccionada,
                        );

                        context.read<PreguntasBloc>().add(
                              PreguntaGuardada(
                                pregunta,
                                esEdicion: preguntaExistente != null,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Banco de preguntas'),
        actions: [
          IconButton(
            tooltip: 'Cargar preguntas de ejemplo',
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Cargar preguntas de ejemplo'),
                content: const Text(
                  'Se agregarán 5 preguntas de Leyes de Newton (nivel '
                  'básico e intermedio) para pruebas rápidas. ¿Continuar?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context
                          .read<PreguntasBloc>()
                          .add(PreguntasDeEjemploSolicitadas());
                    },
                    child: const Text('Cargar'),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Importar preguntas desde PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<PreguntasBloc>(),
                  child: const PantallaImportarPdf(),
                ),
              ),
            ),
          ),
          const BotonCerrarSesion(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<PreguntasBloc, PreguntasEstado>(
        listener: (context, state) {
          if (state is PreguntasFallidas) {
            // Antes este error quedaba invisible porque el modal ya se
            // había cerrado al momento de fallar el guardado.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No se pudo guardar: ${state.mensaje}'),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 6),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PreguntasCargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PreguntasFallidas) {
            return Center(child: Text(state.mensaje));
          }

          final preguntas = (state as PreguntasCargadas).preguntas;

          if (preguntas.isEmpty) {
            return const Center(
                child: Text('Aún no hay preguntas registradas.'));
          }

          return ListView.builder(
            itemCount: preguntas.length,
            itemBuilder: (context, indice) {
              final pregunta = preguntas[indice];
              return ListTile(
                title: Text(pregunta.enunciado),
                subtitle:
                    Text('${pregunta.tema} · ${pregunta.dificultad.name}'),
                onTap: () =>
                    _abrirFormulario(context, preguntaExistente: pregunta),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => context
                      .read<PreguntasBloc>()
                      .add(PreguntaEliminada(pregunta.id)),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}
