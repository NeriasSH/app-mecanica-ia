import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../nucleo/widgets/galaxy_background.dart';
import '../../../autenticacion/presentacion/bloc/perfil_cubit.dart';

import '../../../aprendizaje/presentacion/pantallas/pantalla_desafio.dart';
import '../../../ranking/presentacion/pantallas/pantalla_ranking.dart';
import '../../../teoria/presentacion/pantallas/pantalla_teoria.dart';
import '../../../autenticacion/presentacion/pantallas/pantalla_perfil.dart';

class PantallaPrincipalEstudiante extends StatefulWidget {
  const PantallaPrincipalEstudiante({super.key});

  @override
  State<PantallaPrincipalEstudiante> createState() =>
      _PantallaPrincipalEstudianteState();
}

class _PantallaPrincipalEstudianteState
    extends State<PantallaPrincipalEstudiante> {
  int _indiceSeleccionado = 0;

  final List<Widget> _pantallas = [
    const PantallaDesafio(tema: 'Leyes de Newton'),
    const PantallaTeoria(),
    const PantallaRanking(),
    const PantallaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return GalaxyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: 0.5),
          elevation: 0,
          title: BlocBuilder<PerfilCubit, PerfilEstado>(
            builder: (context, state) {
              if (state is PerfilCargado || state is PerfilActualizado) {
                final usuario = state is PerfilCargado
                    ? state.usuario
                    : (state as PerfilActualizado).usuario;
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('Nvl ${usuario.nivel}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events, color: Colors.blueAccent),
                        const SizedBox(width: 4),
                        Text('${usuario.puntos} pts', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Row(
                      children: List.generate(3, (index) {
                        return Icon(
                          index < usuario.puntosVida ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
        body: IndexedStack(
          index: _indiceSeleccionado,
          children: _pantallas,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _indiceSeleccionado,
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
            onTap: (indice) {
              setState(() {
                _indiceSeleccionado = indice;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch),
                label: 'Desafío',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Teoría',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                label: 'Ranking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
