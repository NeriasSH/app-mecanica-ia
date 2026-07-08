import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../aprendizaje/datos/modelos/pregunta_modelo.dart';
import '../../../aprendizaje/dominio/entidades/desafio.dart';

class DocenteFuenteDatosRemota {
  final FirebaseFirestore _firestore;

  DocenteFuenteDatosRemota({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// CUS-11, paso 6: persiste en la colección preguntas (Tabla 20 / 22).
  Future<void> cargarPregunta(Pregunta pregunta) async {
    await _firestore.collection('preguntas').doc(pregunta.id).set({
      'enunciado': pregunta.enunciado,
      'tema': pregunta.tema,
      'dificultad': PreguntaModelo.dificultadATexto(pregunta.dificultad),
      'alternativas': pregunta.alternativas,
      'respuestaCorrecta': pregunta.indiceRespuestaCorrecta,
    });
  }

  Future<void> actualizarPregunta(Pregunta pregunta) =>
      cargarPregunta(pregunta);

  Future<void> eliminarPregunta(String preguntaId) async {
    await _firestore.collection('preguntas').doc(preguntaId).delete();
  }

  Future<List<PreguntaModelo>> listarPreguntas(
      {NivelDificultad? dificultad}) async {
    Query<Map<String, dynamic>> query = _firestore.collection('preguntas');
    if (dificultad != null) {
      query = query.where(
        'dificultad',
        isEqualTo: PreguntaModelo.dificultadATexto(dificultad),
      );
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => PreguntaModelo.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  /// Carga en lote un conjunto de preguntas de ejemplo, para no
  /// depender de escribirlas a mano durante las pruebas. El tema es
  /// exactamente "Leyes de Newton" para que coincida con el filtro
  /// fijo de PantallaDesafio.
  Future<void> cargarPreguntasDeEjemplo() async {
    final batch = _firestore.batch();
    final coleccion = _firestore.collection('preguntas');

    final ejemplos = [
      {
        'enunciado': '¿Qué establece la Primera Ley de Newton?',
        'tema': 'Leyes de Newton',
        'dificultad': 'basico',
        'alternativas': [
          'Todo cuerpo permanece en reposo o MRU si no hay fuerza neta',
          'La fuerza es igual a masa por aceleración',
          'A toda acción corresponde una reacción igual y opuesta',
          'La energía no se crea ni se destruye',
        ],
        'respuestaCorrecta': 0,
      },
      {
        'enunciado': 'Un cuerpo de 5 kg recibe una fuerza neta de 10 N. '
            '¿Cuál es su aceleración?',
        'tema': 'Leyes de Newton',
        'dificultad': 'basico',
        'alternativas': ['0.5 m/s²', '2 m/s²', '5 m/s²', '50 m/s²'],
        'respuestaCorrecta': 1,
      },
      {
        'enunciado': 'Al nadar, el nadador empuja el agua hacia atrás y '
            'avanza hacia adelante. ¿Qué ley explica este fenómeno?',
        'tema': 'Leyes de Newton',
        'dificultad': 'basico',
        'alternativas': [
          'Primera Ley (Inercia)',
          'Segunda Ley (F = m·a)',
          'Tercera Ley (Acción y reacción)',
          'Ley de gravitación universal',
        ],
        'respuestaCorrecta': 2,
      },
      {
        'enunciado': 'Si la masa de un cuerpo se duplica y la fuerza neta '
            'aplicada se mantiene igual, ¿qué ocurre con su aceleración?',
        'tema': 'Leyes de Newton',
        'dificultad': 'intermedio',
        'alternativas': [
          'Se duplica',
          'Se reduce a la mitad',
          'Permanece igual',
          'Se cuadruplica',
        ],
        'respuestaCorrecta': 1,
      },
      {
        'enunciado': '¿Cuál es la diferencia principal entre masa y peso?',
        'tema': 'Leyes de Newton',
        'dificultad': 'intermedio',
        'alternativas': [
          'No hay diferencia, son lo mismo',
          'La masa varía según el lugar; el peso no',
          'El peso es la cantidad de materia; la masa es una fuerza',
          'La masa es constante; el peso depende de la gravedad del lugar',
        ],
        'respuestaCorrecta': 3,
      },
    ];

    for (final data in ejemplos) {
      batch.set(coleccion.doc(), data);
    }

    await batch.commit();
  }

  /// CUS-12, paso 2: recorre usuarios/{id}/desafios/{id}/resultados
  /// para construir el progreso agregado (implementación simplificada
  /// para el alcance del prototipo; ver nota en el repositorio).
  Future<List<Map<String, dynamic>>> obtenerProgresoEstudiantes() async {
    final snapshot = await _firestore.collection('usuarios').get();
    return snapshot.docs
        .where((doc) => doc.data()['rol'] == 'estudiante')
        .map((doc) => {'uid': doc.id, ...doc.data()})
        .toList();
  }
}
