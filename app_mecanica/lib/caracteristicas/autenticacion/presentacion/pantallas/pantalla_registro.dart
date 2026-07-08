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
                : RutasApp.perfil;
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
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: Validadores.requerido,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Correo electrónico'),
                    validator: Validadores.correo,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contrasenaController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    validator: Validadores.contrasena,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<RolUsuario>(
                    initialValue: _rolSeleccionado,
                    decoration: const InputDecoration(labelText: 'Rol'),
                    items: RolUsuario.values
                        .map((r) =>
                            DropdownMenuItem(value: r, child: Text(r.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _rolSeleccionado = v!),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: cargando ? null : _registrar,
                    child: cargando
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Crear cuenta'),
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
