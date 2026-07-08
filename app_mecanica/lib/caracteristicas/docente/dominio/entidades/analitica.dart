export '../../../aprendizaje/dominio/entidades/desafio.dart' show Pregunta, NivelDificultad;

/// CUS-12: fila de detalle por estudiante, construida a partir del
/// campo "progreso" embebido en usuarios/{id} (Tabla 22).
class EstadisticaEstudiante {
  final String uidEstudiante;
  final String nombreEstudiante;
  final String nivelComprensionActual; // 'alta' | 'media' | 'baja'
  final int puntosTotales;

  const EstadisticaEstudiante({
    required this.uidEstudiante,
    required this.nombreEstudiante,
    required this.nivelComprensionActual,
    required this.puntosTotales,
  });
}

class ResumenAnalitica {
  final int totalEstudiantes;
  final double porcentajeAciertosPromedio;
  final Map<String, int> distribucionPorNivel;
  final List<EstadisticaEstudiante> detallePorEstudiante;

  const ResumenAnalitica({
    required this.totalEstudiantes,
    required this.porcentajeAciertosPromedio,
    required this.distribucionPorNivel,
    required this.detallePorEstudiante,
  });
}
