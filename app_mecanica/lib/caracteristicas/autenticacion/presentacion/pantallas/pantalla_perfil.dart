import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/perfil_cubit.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';
import '../../../../nucleo/utilidades/validadores.dart';

/// CUS-03, Gestionar Perfil.
class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PerfilCubit>().cargar();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          title: const Text('Mi perfil'),
          actions: const [BotonCerrarSesion()],
        ),
        body: BlocConsumer<PerfilCubit, PerfilEstado>(
        listener: (context, state) {
          if (state is PerfilCargado) {
            _nombreController.text = state.usuario.nombre;
          }
          if (state is PerfilActualizado) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil actualizado')),
            );
          }
        },
        builder: (context, state) {
          if (state is PerfilCargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PerfilFallido) {
            return Center(child: Text(state.mensaje));
          }

          final usuario = state is PerfilCargado
              ? state.usuario
              : (state as PerfilActualizado).usuario;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(
                      usuario.nombre.isNotEmpty
                          ? usuario.nombre[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Correo: ${usuario.correo}'),
                  Text('Rol: ${usuario.rol.name}'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: Validadores.requerido,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Efectos de sonido'),
                    subtitle: const Text('Reproducir sonidos al jugar'),
                    value: usuario.sonidoActivado,
                    onChanged: (valor) {
                      context.read<PerfilCubit>().actualizarPerfil(
                            nuevoNombre: usuario.nombre,
                            sonidoActivado: valor,
                          );
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<PerfilCubit>()
                            .actualizarPerfil(nuevoNombre: _nombreController.text.trim());
                      }
                    },
                    child: const Text('Guardar cambios'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
