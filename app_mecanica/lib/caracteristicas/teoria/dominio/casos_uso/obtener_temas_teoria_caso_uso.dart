import '../../datos/fuentes_datos/teoria_fuente_datos_local.dart';
import '../entidades/tema_teoria.dart';

/// CUS-10, Consultar Teoría.
/// Al ser contenido local (sin red ni Firestore), no requiere manejo
/// de Either<Falla, ...>: no hay operación que pueda fallar.
class ObtenerTemasTeoriaCasoUso {
  final TeoriaFuenteDatosLocal fuenteDatos;
  const ObtenerTemasTeoriaCasoUso(this.fuenteDatos);

  List<TemaTeoria> execute() => fuenteDatos.obtenerTemas();
}
