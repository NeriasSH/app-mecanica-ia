import 'package:flutter/material.dart';
import '../../datos/fuentes_datos/teoria_fuente_datos_local.dart';
import '../../dominio/casos_uso/obtener_temas_teoria_caso_uso.dart';
import '../../../../nucleo/widgets/boton_cerrar_sesion.dart';

/// CUS-10, Consultar Teoría.
/// También se activa automáticamente desde CUS-07 cuando el
/// MotorAdaptativo clasifica el nivel de comprensión como "baja"
/// (FlujoPedagogico.bloquearYRedirigirATeoria).
class PantallaTeoria extends StatelessWidget {
  final String? temaDestacadoId;

  const PantallaTeoria({super.key, this.temaDestacadoId});

  @override
  Widget build(BuildContext context) {
    const casoUso = ObtenerTemasTeoriaCasoUso(TeoriaFuenteDatosLocal());
    final temas = casoUso.execute();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Teoría: Mecánica Newtoniana'),
        actions: const [BotonCerrarSesion()],
      ),
      body: ListView.builder(
        itemCount: temas.length,
        itemBuilder: (context, indice) {
          final tema = temas[indice];
          final destacado = tema.id == temaDestacadoId;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: destacado
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: ExpansionTile(
              initiallyExpanded: destacado,
              title: Text(tema.titulo),
              leading: destacado
                  ? const Icon(Icons.priority_high)
                  : const Icon(Icons.menu_book_outlined),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(tema.contenido),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
