import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Autenticación ---
import '../../caracteristicas/autenticacion/datos/fuentes_datos/auth_fuente_datos_remota.dart';
import '../../caracteristicas/autenticacion/datos/repositorios/auth_repositorio_impl.dart';
import '../../caracteristicas/autenticacion/dominio/casos_uso/autenticar_usuario_caso_uso.dart';
import '../../caracteristicas/autenticacion/presentacion/bloc/auth_bloc.dart';
import '../../caracteristicas/autenticacion/presentacion/bloc/perfil_cubit.dart';

// --- Aprendizaje ---
import '../../caracteristicas/aprendizaje/datos/fuentes_datos/desafio_fuente_datos_remota.dart';
import '../../caracteristicas/aprendizaje/datos/repositorios/desafio_repositorio_impl.dart';
import '../../caracteristicas/aprendizaje/dominio/casos_uso/evaluar_resultado_caso_uso.dart';
import '../../caracteristicas/aprendizaje/dominio/casos_uso/motor_adaptativo.dart';
import '../../caracteristicas/aprendizaje/dominio/casos_uso/obtener_preguntas_caso_uso.dart';
import '../../caracteristicas/aprendizaje/presentacion/bloc/learning_bloc.dart';

// --- Docente ---
import '../../caracteristicas/docente/datos/fuentes_datos/docente_fuente_datos_remota.dart';
import '../../caracteristicas/docente/datos/repositorios/docente_repositorio_impl.dart';
import '../../caracteristicas/docente/dominio/casos_uso/gestionar_preguntas_casos_uso.dart';
import '../../caracteristicas/docente/dominio/casos_uso/obtener_analitica_caso_uso.dart';
import '../../caracteristicas/docente/presentacion/bloc/analitica_cubit.dart';
import '../../caracteristicas/docente/presentacion/bloc/preguntas_bloc.dart';

// --- Ranking ---
import '../../caracteristicas/ranking/datos/fuentes_datos/ranking_fuente_datos_remota.dart';
import '../../caracteristicas/ranking/datos/repositorios/ranking_repositorio_impl.dart';
import '../../caracteristicas/ranking/dominio/casos_uso/obtener_ranking_caso_uso.dart';
import '../../caracteristicas/ranking/presentacion/bloc/ranking_cubit.dart';

/// Punto único de construcción de dependencias (composition root).
/// No usa ningún paquete de DI (get_it, provider, etc.) a propósito,
/// para que el flujo de creación quede explícito y fácil de explicar
/// en la sustentación: Firebase -> fuente de datos -> repositorio ->
/// caso de uso -> BLoC/Cubit, respetando siempre la regla de
/// dependencia de Clean Architecture (Figura 5.6).
class InyeccionDependencias {
  InyeccionDependencias._();

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------- Autenticación ----------
  static AuthBloc crearAuthBloc() {
    final fuenteDatos = AuthFuenteDatosRemota(
      firebaseAuth: _firebaseAuth,
      firestore: _firestore,
    );
    final repositorio = AuthRepositorioImpl(fuenteDatos);
    return AuthBloc(
      autenticarUsuarioCasoUso: AutenticarUsuarioCasoUso(repositorio),
      registrarUsuarioCasoUso: RegistrarUsuarioCasoUso(repositorio),
      cerrarSesionCasoUso: CerrarSesionCasoUso(repositorio),
    );
  }

  // ---------- Aprendizaje ----------
  static LearningBloc crearLearningBloc(String uidEstudiante) {
    final fuenteDatos = DesafioFuenteDatosRemota(firestore: _firestore);
    final repositorio = DesafioRepositorioImpl(fuenteDatos);
    const motorAdaptativo = MotorAdaptativo();

    return LearningBloc(
      obtenerPreguntasCasoUso: ObtenerPreguntasCasoUso(repositorio),
      evaluarResultadoUseCase: EvaluarResultadoUseCase(
        repositorio: repositorio,
        motorAdaptativo: motorAdaptativo,
      ),
      uidEstudiante: uidEstudiante,
    );
  }

  // ---------- Docente ----------
  static PreguntasBloc crearPreguntasBloc() {
    final fuenteDatos = DocenteFuenteDatosRemota(firestore: _firestore);
    final repositorio = DocenteRepositorioImpl(fuenteDatos);

    return PreguntasBloc(
      cargarPreguntaCasoUso: CargarPreguntaCasoUso(repositorio),
      actualizarPreguntaCasoUso: ActualizarPreguntaCasoUso(repositorio),
      eliminarPreguntaCasoUso: EliminarPreguntaCasoUso(repositorio),
      listarPreguntasCasoUso: ListarPreguntasCasoUso(repositorio),
      cargarPreguntasDeEjemploCasoUso:
          CargarPreguntasDeEjemploCasoUso(repositorio),
    );
  }

  static AnaliticaCubit crearAnaliticaCubit() {
    final fuenteDatos = DocenteFuenteDatosRemota(firestore: _firestore);
    final repositorio = DocenteRepositorioImpl(fuenteDatos);
    return AnaliticaCubit(ObtenerAnaliticaCasoUso(repositorio));
  }

  // ---------- Perfil (CUS-03) ----------
  static PerfilCubit crearPerfilCubit(String uid) {
    final fuenteDatos = AuthFuenteDatosRemota(
      firebaseAuth: _firebaseAuth,
      firestore: _firestore,
    );
    final repositorio = AuthRepositorioImpl(fuenteDatos);
    return PerfilCubit(
      obtenerPerfilCasoUso: ObtenerPerfilCasoUso(repositorio),
      actualizarPerfilCasoUso: ActualizarPerfilCasoUso(repositorio),
      uid: uid,
    );
  }

  // ---------- Ranking (CUS-09) ----------
  static RankingCubit crearRankingCubit() {
    final fuenteDatos = RankingFuenteDatosRemota(firestore: _firestore);
    final repositorio = RankingRepositorioImpl(fuenteDatos);
    return RankingCubit(ObtenerRankingCasoUso(repositorio));
  }
}
