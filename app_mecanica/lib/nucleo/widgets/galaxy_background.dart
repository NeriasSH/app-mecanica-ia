import 'package:flutter/material.dart';

class GalaxyBackground extends StatelessWidget {
  final Widget child;

  const GalaxyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Definimos los colores del degradado galáctico
    final colorTop = const Color(0xFF0F0C29); // Noche profunda
    final colorMiddle = const Color(0xFF302B63); // Púrpura espacial
    final colorBottom = const Color(0xFF24243E); // Azul oscuro

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorTop, colorMiddle, colorBottom],
        ),
      ),
      child: child,
    );
  }
}
