import '../../dominio/entidades/usuario.dart';

class UsuarioModelo extends Usuario {
  const UsuarioModelo({
    required super.uid,
    required super.nombre,
    required super.correo,
    required super.rol,
  });

  factory UsuarioModelo.fromFirestore(String uid, Map<String, dynamic> data) {
    return UsuarioModelo(
      uid: uid,
      nombre: data['nombre'] as String? ?? '',
      correo: data['correo'] as String? ?? '',
      rol: (data['rol'] == 'docente') ? RolUsuario.docente : RolUsuario.estudiante,
    );
  }
}
