import '../../dominio/entidades/usuario.dart';

class UsuarioModelo extends Usuario {
  const UsuarioModelo({
    required super.uid,
    required super.nombre,
    required super.correo,
    required super.rol,
    super.nivel = 1,
    super.puntos = 0,
    super.puntosVida = 3,
    super.sonidoActivado = true,
  });

  factory UsuarioModelo.fromFirestore(String uid, Map<String, dynamic> data) {
    return UsuarioModelo(
      uid: uid,
      nombre: data['nombre'] as String? ?? '',
      correo: data['correo'] as String? ?? '',
      rol: (data['rol'] == 'docente') ? RolUsuario.docente : RolUsuario.estudiante,
      nivel: data['nivel'] as int? ?? 1,
      puntos: data['puntos'] as int? ?? 0,
      puntosVida: data['puntosVida'] as int? ?? 3,
      sonidoActivado: data['sonidoActivado'] as bool? ?? true,
    );
  }
}
