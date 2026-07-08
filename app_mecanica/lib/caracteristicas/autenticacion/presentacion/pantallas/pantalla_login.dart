import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/entidades/usuario.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_evento.dart';
import '../bloc/auth_estado.dart';
import '../../../../nucleo/constantes/rutas_app.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginSolicitado(
              correo: _correoController.text.trim(),
              contrasena: _contrasenaController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Iniciar sesión')),
        body: BlocConsumer<AuthBloc, AuthEstado>(
          listener: (context, state) {
            if (state is AuthExitoso) {
              final ruta = state.usuario.rol == RolUsuario.docente
                  ? RutasApp.docentePreguntas
                  : RutasApp.desafio;
              Navigator.of(context).pushReplacementNamed(ruta);
            } else if (state is AuthFallido) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.mensaje)));
            }
          },
          builder: (context, state) {
            final cargando = state is AuthCargando;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Correo electrónico'),
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? 'Correo inválido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contrasenaController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: cargando ? null : _iniciarSesion,
                      child: cargando
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Ingresar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(RutasApp.registro),
                      child: const Text('¿No tienes cuenta? Regístrate', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
