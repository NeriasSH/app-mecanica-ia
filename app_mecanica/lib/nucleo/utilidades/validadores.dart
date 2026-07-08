class Validadores {
  Validadores._();

  static String? correo(String? valor) {
    if (valor == null || !valor.contains('@')) return 'Correo inválido';
    return null;
  }

  static String? contrasena(String? valor) {
    if (valor == null || valor.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? requerido(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }
}
