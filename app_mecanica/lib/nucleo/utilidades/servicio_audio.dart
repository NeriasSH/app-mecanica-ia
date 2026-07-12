import 'package:flutter/foundation.dart';

/// Servicio de audio básico. 
/// Actualmente simula la reproducción mediante logs (print).
/// Para habilitar sonidos reales, se puede implementar usando audioplayers u otra librería.
class ServicioAudio {
  static final ServicioAudio _instancia = ServicioAudio._interno();
  factory ServicioAudio() => _instancia;
  ServicioAudio._interno();

  void reproducirPuntos() {
    if (kDebugMode) {
      print('🔊 [AUDIO] Reproduciendo sonido de: Ganar puntos');
    }
  }

  void reproducirPerderVida() {
    if (kDebugMode) {
      print('🔊 [AUDIO] Reproduciendo sonido de: Perder vida');
    }
  }

  void reproducirSubirNivel() {
    if (kDebugMode) {
      print('🔊 [AUDIO] Reproduciendo sonido de: Subir de Nivel');
    }
  }

  void reproducirBoton() {
    if (kDebugMode) {
      print('🔊 [AUDIO] Reproduciendo sonido de: Click botón');
    }
  }
}
