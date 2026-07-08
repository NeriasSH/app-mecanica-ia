import 'package:cloud_firestore/cloud_firestore.dart';
import '../../dominio/entidades/desafio.dart';
import '../modelos/pregunta_modelo.dart';

/// Corresponde a FirestoreRepository en tu Figura 5.5; aquí se separó
/// en fuente de datos (SDK) + repositorio (Capa de Datos), conforme al
/// diagrama de paquetes (Figura 5.6).
class DesafioFuenteDatosRemota {
  final FirebaseFirestore _firestore;

  DesafioFuenteDatosRemota({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// CUS-04: consulta la colección preguntas filtrando por tema y
  /// dificultad (Tabla 13).
  Future<List<PreguntaModelo>> obtenerPreguntas({
    required String tema,
    required NivelDificultad dificultad,
  }) async {
    final query = await _firestore
        .collection('preguntas')
        .where('tema', isEqualTo: tema)
        .where('dificultad', isEqualTo: PreguntaModelo.dificultadATexto(dificultad))
        .get();

    return query.docs
        .map((doc) => PreguntaModelo.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  /// CUS-08: persiste en desafios/{id}/resultados y actualiza el
  /// progreso embebido del estudiante y su documento en ranking
  /// (Tabla 22).
  Future<void> guardarResultado({
    required String uidEstudiante,
    required String desafioId,
    required Resultado resultado,
  }) async {
    final batch = _firestore.batch();

    final resultadoRef = _firestore
        .collection('usuarios')
        .doc(uidEstudiante)
        .collection('desafios')
        .doc(desafioId)
        .collection('resultados')
        .doc();

    batch.set(resultadoRef, {
      'tiempoSegundos': resultado.tiempoSegundos,
      'intentos': resultado.intentos,
      'nivel': resultado.nivel.name,
    });

    final usuarioRef = _firestore.collection('usuarios').doc(uidEstudiante);
    batch.set(
      usuarioRef,
      {
        'progreso': {
          'nivelActual': resultado.nivel.name,
          'puntosTotales': FieldValue.increment(_puntosPorNivel(resultado.nivel)),
        },
      },
      SetOptions(merge: true),
    );

    final rankingRef = _firestore.collection('ranking').doc(uidEstudiante);
    batch.set(
      rankingRef,
      {'puntos': FieldValue.increment(_puntosPorNivel(resultado.nivel))},
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  int _puntosPorNivel(nivel) {
    switch (nivel.toString()) {
      case 'NivelComprension.alta':
        return 10;
      case 'NivelComprension.media':
        return 5;
      default:
        return 2;
    }
  }
}
