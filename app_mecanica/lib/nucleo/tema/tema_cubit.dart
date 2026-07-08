import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Controla qué ThemeMode usa la app (claro / oscuro / según el sistema).
/// Es intencionalmente mínimo ahora; cuando agregues el toggle visual
/// del tema galáctico, solo se conecta un botón a
/// context.read<TemaCubit>().alternar().
class TemaCubit extends Cubit<ThemeMode> {
  TemaCubit() : super(ThemeMode.system);

  void alternar() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void establecer(ThemeMode modo) => emit(modo);
}
