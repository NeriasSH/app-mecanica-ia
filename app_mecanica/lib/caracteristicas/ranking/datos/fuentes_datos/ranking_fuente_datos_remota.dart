import 'package:cloud_firestore/cloud_firestore.dart';
import '../../dominio/entidades/estudiante_ranking.dart';

class RankingFuenteDatosRemota {
  final FirebaseFirestore _firestore;

  RankingFuenteDatosRemota({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// CUS-09, paso 2: consulta la colección ranking (desnormalizada,
  /// Tabla 22) ordenada de mayor a menor puntaje, y cruza el nombre
  /// desde usuarios/{uid} para presentarlo en pantalla.
  Future<List<EstudianteRanking>> obtenerRanking() async {
    final query = await _firestore
        .collection('ranking')
        .orderBy('puntos', descending: true)
        .limit(50)
        .get();

    final resultado = <EstudianteRanking>[];
    var posicion = 1;

    for (final doc in query.docs) {
      final uid = doc.id;
      final puntos = doc.data()['puntos'] as int? ?? 0;

      final usuarioDoc = await _firestore.collection('usuarios').doc(uid).get();
      final nombre = usuarioDoc.data()?['nombre'] as String? ?? 'Estudiante';

      resultado.add(EstudianteRanking(
        uid: uid,
        nombre: nombre,
        puntos: puntos,
        posicion: posicion,
      ));
      posicion++;
    }

    return resultado;
  }
}
