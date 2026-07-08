import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_flutter/caracteristicas/aprendizaje/dominio/casos_uso/motor_adaptativo.dart';

/// Prueba de equivalencia funcional: cada caso corresponde a una hoja
/// del árbol entrenado (max_depth = 3, 5 hojas, Accuracy = 91.23%,
/// Capítulo 4), verificando que la traducción a reglas Dart produce
/// exactamente la misma salida que el DecisionTreeClassifier.
void main() {
  const motor = MotorAdaptativo();

  group('MotorAdaptativo.predecirNivel (CUS-07)', () {
    test('intentos<=2 y tiempo<=45s => alta', () {
      final nivel = motor.predecirNivel(tiempoSegundos: 30, intentos: 1);
      expect(nivel, NivelComprension.alta);
    });

    test('intentos<=2 y tiempo>45s => media', () {
      final nivel = motor.predecirNivel(tiempoSegundos: 50, intentos: 2);
      expect(nivel, NivelComprension.media);
    });

    test('intentos>2 y tiempo<=30s => media', () {
      final nivel = motor.predecirNivel(tiempoSegundos: 20, intentos: 3);
      expect(nivel, NivelComprension.media);
    });

    test('intentos>2 y tiempo>30s => baja', () {
      final nivel = motor.predecirNivel(tiempoSegundos: 40, intentos: 4);
      expect(nivel, NivelComprension.baja);
    });

    test('caso límite exacto: intentos=2, tiempo=45.0 => alta', () {
      final nivel = motor.predecirNivel(tiempoSegundos: 45.0, intentos: 2);
      expect(nivel, NivelComprension.alta);
    });
  });

  group('MotorAdaptativo.adaptarFlujo (CUS-07)', () {
    test('alta => avanzarSiguienteTema', () {
      expect(motor.adaptarFlujo(NivelComprension.alta),
          FlujoPedagogico.avanzarSiguienteTema);
    });

    test('media => repasoReforzado', () {
      expect(motor.adaptarFlujo(NivelComprension.media),
          FlujoPedagogico.repasoReforzado);
    });

    test('baja => bloquearYRedirigirATeoria', () {
      expect(motor.adaptarFlujo(NivelComprension.baja),
          FlujoPedagogico.bloquearYRedirigirATeoria);
    });
  });
}
