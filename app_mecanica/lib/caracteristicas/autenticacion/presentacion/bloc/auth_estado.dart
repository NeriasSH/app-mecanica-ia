import 'package:equatable/equatable.dart';
import '../../dominio/entidades/usuario.dart';

abstract class AuthEstado extends Equatable {
  const AuthEstado();
  @override
  List<Object?> get props => [];
}

class AuthInicial extends AuthEstado {}
class AuthCargando extends AuthEstado {}

class AuthExitoso extends AuthEstado {
  final Usuario usuario;
  const AuthExitoso(this.usuario);
  @override
  List<Object?> get props => [usuario];
}

class AuthFallido extends AuthEstado {
  final String mensaje;
  const AuthFallido(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}
