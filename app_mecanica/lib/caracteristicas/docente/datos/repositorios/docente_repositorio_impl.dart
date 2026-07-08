import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../../dominio/entidades/analitica.dart';
import '../../dominio/repositorios/docente_repositorio.dart';
import '../fuentes_datos/docente_fuente_datos_remota.dart';

class DocenteRepositorioImpl implements DocenteRepositorio {
  final DocenteFuenteDatosRemota fuenteDatosRemota;

  const DocenteRepositorioImpl(this.fuenteDatosRemota);

  @override
  Future<Either<Falla, void>> cargarPregunta(Pregunta pregunta) async {
    try {
      await fuenteDatosRemota.cargarPregunta(pregunta);
      return const Right(null);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<Either<Falla, void>> actualizarPregunta(Pregunta pregunta) async {
    try {
      await fuenteDatosRemota.actualizarPregunta(pregunta);
      return const Right(null);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<Either<Falla, void>> eliminarPregunta(String preguntaId) async {
    try {
      await fuenteDatosRemota.eliminarPregunta(preguntaId);
      return const Right(null);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<Either<Falla, List<Pregunta>>> listarPreguntas({
    NivelDificultad? dificultad,
  }) async {
    try {
      final preguntas =
          await fuenteDatosRemota.listarPreguntas(dificultad: dificultad);
      return Right(preguntas);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  /// CUS-12: agrega el campo "progreso" embebido de cada estudiante
  /// (Tabla 22: progreso.puntosTotales, progreso.nivelActual), tal
  /// como está realmente modelado en Firestore -no una colección
  /// aparte de historial-.
  @override
  Future<Either<Falla, ResumenAnalitica>> obtenerAnalitica() async {
    try {
      final estudiantes = await fuenteDatosRemota.obtenerProgresoEstudiantes();

      if (estudiantes.isEmpty) {
        return const Right(ResumenAnalitica(
          totalEstudiantes: 0,
          porcentajeAciertosPromedio: 0,
          distribucionPorNivel: {},
          detallePorEstudiante: [],
        ));
      }

      final detalle = <EstadisticaEstudiante>[];
      final distribucion = <String, int>{'alta': 0, 'media': 0, 'baja': 0};

      for (final e in estudiantes) {
        final progreso = (e['progreso'] as Map<String, dynamic>?) ?? {};
        final nivel = progreso['nivelActual'] as String? ?? 'media';
        final puntos = progreso['puntosTotales'] as int? ?? 0;

        distribucion[nivel] = (distribucion[nivel] ?? 0) + 1;

        detalle.add(EstadisticaEstudiante(
          uidEstudiante: e['uid'] as String,
          nombreEstudiante: e['nombre'] as String? ?? e['uid'] as String,
          nivelComprensionActual: nivel,
          puntosTotales: puntos,
        ));
      }

      return Right(ResumenAnalitica(
        totalEstudiantes: estudiantes.length,
        porcentajeAciertosPromedio:
            (distribucion['alta']! / estudiantes.length) * 100,
        distribucionPorNivel: distribucion,
        detallePorEstudiante: detalle,
      ));
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }

  @override
  Future<Either<Falla, void>> cargarPreguntasDeEjemplo() async {
    try {
      await fuenteDatosRemota.cargarPreguntasDeEjemplo();
      return const Right(null);
    } catch (_) {
      return const Left(SinConexionFalla());
    }
  }
}
