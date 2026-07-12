enum RolUsuario { estudiante, docente }

class Usuario {
  final String uid;
  final String nombre;
  final String correo;
  final RolUsuario rol;
  final int nivel;
  final int puntos;
  final int puntosVida;
  final bool sonidoActivado;

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.rol,
    this.nivel = 1,
    this.puntos = 0,
    this.puntosVida = 3,
    this.sonidoActivado = true,
  });
}
