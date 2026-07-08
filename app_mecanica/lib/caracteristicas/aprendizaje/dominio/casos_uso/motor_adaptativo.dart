enum NivelComprension { alta, media, baja }

enum FlujoPedagogico {
  avanzarSiguienteTema,
  repasoReforzado,
  bloquearYRedirigirATeoria,
}

/// Motor adaptativo del sistema, basado en el Árbol de Decisión
/// entrenado en el Capítulo 4 (Accuracy = 91.23%).
/// Caso de uso: Adaptar Dificultad (CUS-07).
class MotorAdaptativo {
  const MotorAdaptativo();

  /// Clasifica el nivel de comprensión del estudiante.
  /// Traducción directa de las reglas if-else generadas por el
  /// DecisionTreeClassifier (max_depth = 3).
  NivelComprension predecirNivel({
    required double tiempoSegundos,
    required int intentos,
  }) {
    if (intentos <= 2) {
      if (tiempoSegundos <= 45.0) {
        return NivelComprension.alta;
      }
      return NivelComprension.media;
    } else {
      if (tiempoSegundos <= 30.0) {
        return NivelComprension.media;
      }
      return NivelComprension.baja;
    }
  }

  /// Determina la acción pedagógica y de gamificación (Octalysis:
  /// Desarrollo y Posesión / Retroalimentación) asociada al nivel de
  /// comprensión detectado. Corresponde al paso 3 del flujo básico de
  /// CUS-07.
  FlujoPedagogico adaptarFlujo(NivelComprension nivel) {
    switch (nivel) {
      case NivelComprension.alta:
        return FlujoPedagogico.avanzarSiguienteTema;
      case NivelComprension.media:
        return FlujoPedagogico.repasoReforzado;
      case NivelComprension.baja:
        return FlujoPedagogico.bloquearYRedirigirATeoria;
    }
  }
}
