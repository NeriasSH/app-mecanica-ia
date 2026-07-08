enum RolUsuario { estudiante, docente }

class Usuario {
  final String uid;
  final String nombre;
  final String correo;
  final RolUsuario rol;

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.rol,
  });
}
