import 'package:dartz/dartz.dart';
import '../../../../nucleo/errores/falla.dart';
import '../entidades/desafio.dart';
import '../repositorios/desafio_repositorio.dart';
import 'motor_adaptativo.dart';

/// CUS-06, Evaluar Resultado (<<include>> de CUS-05).
/// Invoca CUS-07 (Adaptar Dificultad) a través de MotorAdaptativo y
/// CUS-08 (Registrar Progreso) a través del repositorio.
class EvaluarResultadoUseCase {
  final DesafioRepositorio repositorio;
  final MotorAdaptativo motorAdaptativo;

  const EvaluarResultadoUseCase({
    required this.repositorio,
    required this.motorAdaptativo,
  });

  Future<Either<Falla, ResultadoEvaluado>> execute({
    required String uidEstudiante,
    required String desafioId,
    required String preguntaId,
    required double tiempoSegundos,
    required int intentos,
  }) async {
    // CUS-07: Adaptar Dificultad (Árbol de Decisión).
    final nivel = motorAdaptativo.predecirNivel(
      tiempoSegundos: tiempoSegundos,
      intentos: intentos,
    );
    final flujo = motorAdaptativo.adaptarFlujo(nivel);

    final resultado = Resultado(
      preguntaId: preguntaId,
      tiempoSegundos: tiempoSegundos,
      intentos: intentos,
      nivel: nivel,
    );

    // CUS-08: Registrar Progreso.
    final guardado = await repositorio.guardarResultado(
      uidEstudiante: uidEstudiante,
      desafioId: desafioId,
      resultado: resultado,
    );

    return guardado.fold(
      (falla) => Left(falla),
      (_) => Right(ResultadoEvaluado(resultado: resultado, flujo: flujo)),
    );
  }
}

/// Valor de retorno compuesto: el Resultado persistido más el
/// FlujoPedagogico que la UI debe aplicar a continuación (avanzar,
/// repasar, o bloquear y redirigir a CUS-10 Consultar Teoría).
class ResultadoEvaluado {
  final Resultado resultado;
  final FlujoPedagogico flujo;

  const ResultadoEvaluado({required this.resultado, required this.flujo});
}
