import '../../dominio/entidades/tema_teoria.dart';

/// Fuente de datos local: el contenido teórico corresponde a los
/// temas oficiales del libro Ciencia, Tecnología y Ambiente 5
/// (Editorial Santillana, alcance definido en 1.6), por lo que no
/// requiere persistirse en Firestore -es contenido estático de la app-.
class TeoriaFuenteDatosLocal {
  const TeoriaFuenteDatosLocal();

  List<TemaTeoria> obtenerTemas() {
    return const [
      TemaTeoria(
        id: 'primera-ley',
        titulo: 'Primera Ley de Newton (Inercia)',
        contenido:
            'Todo cuerpo permanece en su estado de reposo o de movimiento '
            'rectilíneo uniforme, a menos que una fuerza externa actúe sobre '
            'él. Por ejemplo, un pasajero se inclina hacia adelante cuando el '
            'bus frena bruscamente: su cuerpo tiende a seguir en movimiento.',
      ),
      TemaTeoria(
        id: 'segunda-ley',
        titulo: 'Segunda Ley de Newton (F = m·a)',
        contenido:
            'La aceleración de un cuerpo es directamente proporcional a la '
            'fuerza neta aplicada e inversamente proporcional a su masa. '
            'Se expresa como F = m × a. A mayor fuerza aplicada sobre una '
            'misma masa, mayor será la aceleración obtenida.',
      ),
      TemaTeoria(
        id: 'tercera-ley',
        titulo: 'Tercera Ley de Newton (Acción y Reacción)',
        contenido:
            'Cuando un cuerpo ejerce una fuerza sobre otro, este último '
            'ejerce una fuerza de igual magnitud y dirección opuesta sobre '
            'el primero. Por ejemplo, al nadar, el nadador empuja el agua '
            'hacia atrás y el agua lo impulsa hacia adelante.',
      ),
      TemaTeoria(
        id: 'peso-masa',
        titulo: 'Diferencia entre Masa y Peso',
        contenido:
            'La masa es la cantidad de materia de un cuerpo y no cambia '
            'según el lugar. El peso es la fuerza de gravedad que actúa '
            'sobre esa masa (P = m × g) y sí varía según el planeta o '
            'lugar donde se mida.',
      ),
    ];
  }
}
