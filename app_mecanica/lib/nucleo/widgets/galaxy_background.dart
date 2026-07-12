import 'package:flutter/material.dart';

class GalaxyBackground extends StatefulWidget {
  final Widget child;

  const GalaxyBackground({super.key, required this.child});

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colorTop = Color(0xFF0F0C29); // Noche profunda
    const colorMiddle = Color(0xFF302B63); // Púrpura espacial
    const colorBottom = Color(0xFF24243E); // Azul oscuro

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value, -1.0),
              end: Alignment(-_animation.value, 1.0),
              colors: const [colorTop, colorMiddle, colorBottom],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
