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
                  : RutasApp.principalEstudiante;
              Navigator.of(context).pushReplacementNamed(ruta);
            } else if (state is AuthFallido) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.mensaje)));
            }
          },
          builder: (context, state) {
            final cargando = state is AuthCargando;
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Bienvenido',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _correoController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Correo electrónico',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              validator: (v) =>
                                  (v == null || !v.contains('@')) ? 'Correo inválido' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _contrasenaController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              validator: (v) =>
                                  (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: cargando ? null : _iniciarSesion,
                                child: cargando
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Text(
                                        'Ingresar',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.of(context).pushNamed(RutasApp.registro),
                              child: const Text('¿No tienes cuenta? Regístrate'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
