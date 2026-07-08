import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../caracteristicas/autenticacion/presentacion/bloc/auth_bloc.dart';
import '../../caracteristicas/autenticacion/presentacion/bloc/auth_evento.dart';
import '../constantes/rutas_app.dart';

/// Botón reutilizable para cerrar sesión, pensado para colocarse en el
/// AppBar de cualquier pantalla que requiera sesión activa
/// (PantallaDesafio, PantallaCargaPreguntas, PantallaAnalitica).
/// Dispara CerrarSesionSolicitado y regresa a Login, limpiando el
/// historial de navegación para que no se pueda volver atrás con el
/// botón físico/gesto del dispositivo.
class BotonCerrarSesion extends StatelessWidget {
  const BotonCerrarSesion({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Cerrar sesión',
      icon: const Icon(Icons.logout),
      onPressed: () {
        context.read<AuthBloc>().add(CerrarSesionSolicitado());
        Navigator.of(context).pushNamedAndRemoveUntil(
          RutasApp.login,
          (ruta) => false,
        );
      },
    );
  }
}
