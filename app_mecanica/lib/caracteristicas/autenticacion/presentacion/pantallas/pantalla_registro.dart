import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dominio/entidades/usuario.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_evento.dart';
import '../bloc/auth_estado.dart';
import '../../../../nucleo/constantes/rutas_app.dart';
import '../../../../nucleo/utilidades/validadores.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';

/// CUS-01, Registrar Usuario.
class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  RolUsuario _rolSeleccionado = RolUsuario.estudiante;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegistroSolicitado(
              nombre: _nombreController.text.trim(),
              correo: _correoController.text.trim(),
              contrasena: _contrasenaController.text,
              rol: _rolSeleccionado,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: BlocConsumer<AuthBloc, AuthEstado>(
        listener: (context, state) {
          if (state is AuthExitoso) {
            // Al ser una cuenta recién creada, el estudiante pasa
            // primero por CUS-03 (Gestionar Perfil) para personalizar
            // su nombre/avatar antes de entrar al primer desafío.
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
                            'Únete a la Aventura',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: Validadores.requerido,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _correoController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: Validadores.correo,
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
                            validator: Validadores.contrasena,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<RolUsuario>(
                            initialValue: _rolSeleccionado,
                            decoration: InputDecoration(
                              labelText: 'Rol',
                              prefixIcon: const Icon(Icons.badge),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            items: RolUsuario.values
                                .map((r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r.name.substring(0, 1).toUpperCase() + r.name.substring(1))))
                                .toList(),
                            onChanged: (v) => setState(() => _rolSeleccionado = v!),
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
                              onPressed: cargando ? null : _registrar,
                              child: cargando
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Crear cuenta',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
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
