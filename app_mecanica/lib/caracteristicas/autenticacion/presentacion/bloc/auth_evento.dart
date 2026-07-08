import 'package:equatable/equatable.dart';
import '../../dominio/entidades/usuario.dart';

abstract class AuthEvento extends Equatable {
  const AuthEvento();
  @override
  List<Object?> get props => [];
}

class LoginSolicitado extends AuthEvento {
  final String correo;
  final String contrasena;

  const LoginSolicitado({required this.correo, required this.contrasena});

  @override
  List<Object?> get props => [correo, contrasena];
}

class RegistroSolicitado extends AuthEvento {
  final String nombre;
  final String correo;
  final String contrasena;
  final RolUsuario rol;

  const RegistroSolicitado({
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.rol,
  });

  @override
  List<Object?> get props => [nombre, correo, contrasena, rol];
}

class CerrarSesionSolicitado extends AuthEvento {}
