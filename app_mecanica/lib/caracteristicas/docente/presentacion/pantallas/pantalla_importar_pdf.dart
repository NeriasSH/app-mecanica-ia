import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../dominio/casos_uso/importar_preguntas_pdf_caso_uso.dart';
import '../../../aprendizaje/dominio/entidades/desafio.dart';
import '../bloc/preguntas_bloc.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';

/// CUS-11 (extensión), Importar Preguntas desde PDF.
/// El docente selecciona un PDF redactado con la plantilla definida en
/// ImportarPreguntasPdfCasoUso, revisa la vista previa y confirma el
/// guardado en lote.
class PantallaImportarPdf extends StatefulWidget {
  const PantallaImportarPdf({super.key});

  @override
  State<PantallaImportarPdf> createState() => _PantallaImportarPdfState();
}

class _PantallaImportarPdfState extends State<PantallaImportarPdf> {
  bool _procesando = false;
  ResultadoImportacionPdf? _resultado;
  String? _errorLectura;

  Future<void> _seleccionarYProcesarPdf() async {
    setState(() {
      _procesando = true;
      _errorLectura = null;
      _resultado = null;
    });

    try {
      final archivo = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (archivo == null || archivo.files.single.bytes == null) {
        setState(() => _procesando = false);
        return;
      }

      final bytes = archivo.files.single.bytes!;
      final documento = PdfDocument(inputBytes: bytes);
      final texto = PdfTextExtractor(documento).extractText();
      documento.dispose();

      const casoUso = ImportarPreguntasPdfCasoUso();
      final resultado = casoUso.execute(texto);

      setState(() {
        _resultado = resultado;
        _procesando = false;
      });
    } catch (e) {
      setState(() {
        _errorLectura = 'No se pudo leer el PDF: $e';
        _procesando = false;
      });
    }
  }

  void _guardarTodas(BuildContext context) {
    final preguntas = _resultado?.preguntas ?? [];
    for (final pregunta in preguntas) {
      context.read<PreguntasBloc>().add(
            PreguntaGuardada(pregunta, esEdicion: false),
          );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${preguntas.length} preguntas enviadas a guardar')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
      appBar: AppBar(title: const Text('Importar preguntas desde PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'El PDF debe seguir esta plantilla, una pregunta tras otra:\n\n'
                  'TEMA: Leyes de Newton\n'
                  'DIFICULTAD: basico\n'
                  '1. ¿Cuál es la unidad de la fuerza?\n'
                  'a) Joule\n'
                  'b) Newton *\n'
                  'c) Watt\n'
                  'd) Pascal\n\n'
                  'El asterisco (*) marca la alternativa correcta.',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _procesando ? null : _seleccionarYProcesarPdf,
              icon: const Icon(Icons.upload_file),
              label: Text(_procesando ? 'Procesando...' : 'Seleccionar PDF'),
            ),
            if (_errorLectura != null) ...[
              const SizedBox(height: 12),
              Text(_errorLectura!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 16),
            if (_resultado != null) ...[
              Text(
                '${_resultado!.preguntas.length} preguntas reconocidas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (_resultado!.lineasNoReconocidas.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${_resultado!.lineasNoReconocidas.length} línea(s) no '
                    'reconocida(s) — revisa el formato del PDF.',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _resultado!.preguntas.length,
                  itemBuilder: (context, indice) {
                    final Pregunta p = _resultado!.preguntas[indice];
                    return Card(
                      child: ListTile(
                        title: Text(p.enunciado),
                        subtitle: Text(
                          '${p.tema} · ${p.dificultad.name} · '
                          'Correcta: ${p.alternativas[p.indiceRespuestaCorrecta]}',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _resultado!.preguntas.isEmpty
                    ? null
                    : () => _guardarTodas(context),
                child:
                    Text('Guardar ${_resultado!.preguntas.length} preguntas'),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
