import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'nucleo/tema/app_theme.dart';
import 'nucleo/tema/tema_cubit.dart';
import 'nucleo/constantes/rutas_app.dart';
import 'nucleo/inyeccion_dependencias/inyeccion_dependencias.dart';

import 'caracteristicas/autenticacion/presentacion/bloc/auth_bloc.dart';
import 'caracteristicas/autenticacion/presentacion/bloc/auth_estado.dart';
import 'caracteristicas/autenticacion/presentacion/pantallas/pantalla_login.dart';
import 'caracteristicas/autenticacion/presentacion/pantallas/pantalla_registro.dart';
import 'caracteristicas/autenticacion/presentacion/bloc/perfil_cubit.dart';
import 'caracteristicas/autenticacion/presentacion/pantallas/pantalla_perfil.dart';

import 'caracteristicas/aprendizaje/presentacion/pantallas/pantalla_desafio.dart';
import 'caracteristicas/estudiante/presentacion/pantallas/pantalla_principal_estudiante.dart';

import 'caracteristicas/ranking/presentacion/bloc/ranking_cubit.dart';
import 'caracteristicas/ranking/presentacion/pantallas/pantalla_ranking.dart';

import 'caracteristicas/teoria/presentacion/pantallas/pantalla_teoria.dart';

import 'caracteristicas/docente/presentacion/bloc/preguntas_bloc.dart';
import 'caracteristicas/docente/presentacion/bloc/analitica_cubit.dart';
import 'caracteristicas/docente/presentacion/pantallas/pantalla_carga_preguntas.dart';
import 'caracteristicas/docente/presentacion/pantallas/pantalla_analitica.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TemaCubit>(create: (_) => TemaCubit()),
        BlocProvider<AuthBloc>(
            create: (_) => InyeccionDependencias.crearAuthBloc()),
      ],
      child: BlocBuilder<TemaCubit, ThemeMode>(
        builder: (context, modoTema) {
          return MaterialApp(
            title: 'Mecánica Newtoniana',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.claro,
            darkTheme: AppTheme.oscuro,
            themeMode: modoTema,
            initialRoute: RutasApp.login,
            routes: {
              RutasApp.login: (_) => const PantallaLogin(),
              RutasApp.registro: (_) => const PantallaRegistro(),

              // El uid ya no es fijo: se toma del AuthBloc (usuario que
              // completó CUS-02 Autenticar Usuario). Si por algún error
              // se navega aquí sin sesión activa, se redirige a Login
              // en vez de fallar.
              // Hub principal para el estudiante
              RutasApp.principalEstudiante: (context) {
                final estadoAuth = context.watch<AuthBloc>().state;
                if (estadoAuth is! AuthExitoso) {
                  return const PantallaLogin();
                }
                final uidActual = estadoAuth.usuario.uid;

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => InyeccionDependencias.crearLearningBloc(uidActual),
                    ),
                    BlocProvider<PerfilCubit>(
                      create: (_) => InyeccionDependencias.crearPerfilCubit(uidActual),
                    ),
                    BlocProvider<RankingCubit>(
                      create: (_) => InyeccionDependencias.crearRankingCubit(),
                    ),
                  ],
                  child: const PantallaPrincipalEstudiante(),
                );
              },

              // Las rutas sueltas se pueden mantener para casos directos o eliminarse,
              // las mantenemos para no romper referencias internas de Navigator.pushNamed
              RutasApp.desafio: (context) {
                final estadoAuth = context.watch<AuthBloc>().state;
                if (estadoAuth is! AuthExitoso) {
                  return const PantallaLogin();
                }
                return BlocProvider(
                  create: (_) => InyeccionDependencias.crearLearningBloc(
                    estadoAuth.usuario.uid,
                  ),
                  child: const PantallaDesafio(tema: 'Leyes de Newton'),
                );
              },

              RutasApp.docentePreguntas: (_) => BlocProvider<PreguntasBloc>(
                    create: (_) => InyeccionDependencias.crearPreguntasBloc(),
                    child: const PantallaCargaPreguntas(),
                  ),

              RutasApp.docenteAnalitica: (_) => BlocProvider<AnaliticaCubit>(
                    create: (_) => InyeccionDependencias.crearAnaliticaCubit(),
                    child: const PantallaAnalitica(),
                  ),

              // CUS-03: requiere sesión activa, igual que /desafio.
              RutasApp.perfil: (context) {
                final estadoAuth = context.watch<AuthBloc>().state;
                if (estadoAuth is! AuthExitoso) {
                  return const PantallaLogin();
                }
                return BlocProvider<PerfilCubit>(
                  create: (_) => InyeccionDependencias.crearPerfilCubit(
                    estadoAuth.usuario.uid,
                  ),
                  child: const PantallaPerfil(),
                );
              },

              // CUS-09: no depende de un uid específico, cualquier
              // estudiante autenticado puede consultarlo.
              RutasApp.ranking: (context) {
                final estadoAuth = context.watch<AuthBloc>().state;
                final uidActual =
                    estadoAuth is AuthExitoso ? estadoAuth.usuario.uid : null;
                return BlocProvider<RankingCubit>(
                  create: (_) => InyeccionDependencias.crearRankingCubit(),
                  child: PantallaRanking(uidEstudianteActual: uidActual),
                );
              },

              // CUS-10: contenido estático, no requiere BlocProvider.
              RutasApp.teoria: (_) => const PantallaTeoria(),
            },
          );
        },
      ),
    );
  }
}
