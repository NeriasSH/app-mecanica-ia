abstract class Falla {
  final String mensaje;
  const Falla(this.mensaje);
}

class CredencialesInvalidasFalla extends Falla {
  const CredencialesInvalidasFalla()
      : super('Correo o contraseña incorrectos.');
}

class SinConexionFalla extends Falla {
  const SinConexionFalla() : super('Sin conexión a internet. Verifica tu red.');
}

class TiempoAgotadoFalla extends Falla {
  const TiempoAgotadoFalla()
      : super(
            'La conexión tardó demasiado. Verifica tu red e inténtalo de nuevo.');
}

class RolNoEncontradoFalla extends Falla {
  const RolNoEncontradoFalla()
      : super('No se pudo determinar el rol del usuario.');
}

class HistorialNoEncontradoFalla extends Falla {
  const HistorialNoEncontradoFalla()
      : super('No se encontró historial previo del estudiante.');
}
