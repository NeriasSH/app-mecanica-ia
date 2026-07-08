import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../../../aprendizaje/dominio/entidades/desafio.dart';
import '../repositorios/docente_repositorio.dart';

/// Corresponde a CUS-0X "Gestionar Banco de Preguntas": el docente crea,
/// edita y elimina preguntas que luego consume el MotorAdaptativo.
class CargarPreguntaCasoUso {
  final DocenteRepositorio repositorio;
  const CargarPreguntaCasoUso(this.repositorio);

  Future<Either<Falla, void>> execute(Pregunta pregunta) {
    return repositorio.cargarPregunta(pregunta);
  }
}

class ActualizarPreguntaCasoUso {
  final DocenteRepositorio repositorio;
  const ActualizarPreguntaCasoUso(this.repositorio);

  Future<Either<Falla, void>> execute(Pregunta pregunta) {
    return repositorio.actualizarPregunta(pregunta);
  }
}

class EliminarPreguntaCasoUso {
  final DocenteRepositorio repositorio;
  const EliminarPreguntaCasoUso(this.repositorio);

  Future<Either<Falla, void>> execute(String preguntaId) {
    return repositorio.eliminarPregunta(preguntaId);
  }
}

class ListarPreguntasCasoUso {
  final DocenteRepositorio repositorio;
  const ListarPreguntasCasoUso(this.repositorio);

  Future<Either<Falla, List<Pregunta>>> execute({NivelDificultad? dificultad}) {
    return repositorio.listarPreguntas(dificultad: dificultad);
  }
}

class CargarPreguntasDeEjemploCasoUso {
  final DocenteRepositorio repositorio;
  const CargarPreguntasDeEjemploCasoUso(this.repositorio);

  Future<Either<Falla, void>> execute() {
    return repositorio.cargarPreguntasDeEjemplo();
  }
}
