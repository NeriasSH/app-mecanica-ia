#!/bin/bash

# ==============================================================================
# SCRIPT DE MANTENIMIENTO: Limpieza de Desarrollo y Navegación
# ==============================================================================

echo "=== Iniciando limpieza de herramientas de desarrollo y navegadores ==="
echo ""

# 1. Google Chrome (Caché y almacenamiento web temporal)
echo "[1/4] Limpiando caché de Google Chrome..."
if [ -d "$HOME/.config/google-chrome" ]; then
  # Borra la caché principal y la caché de código multimedia
  rm -rf "$HOME/.config/google-chrome/Default/Cache"/*
  rm -rf "$HOME/.config/google-chrome/Default/Code Cache"/*
  rm -rf "$HOME/.config/google-chrome/Default/GPUCache"/*
  echo "✔ Caché de Chrome eliminada."
else
  echo "• No se detectó el directorio de Chrome en la ruta estándar."
fi
echo ""

# 2. Visual Studio Code (Caché interna y de extensiones)
# En image_b0192d.png vemos que .vscode ocupa 2.0 GB y .config ocupa 4.1 GB
echo "[2/4] Limpiando caché y archivos temporales de VS Code..."
if [ -d "$HOME/.config/Code" ]; then
  rm -rf "$HOME/.config/Code/Cache"/*
  rm -rf "$HOME/.config/Code/CachedData"/*
  rm -rf "$HOME/.config/Code/CachedExtensionVSIXs"/*
  rm -rf "$HOME/.config/Code/Code Cache"/*
  rm -rf "$HOME/.config/Code/GPUCache"/*
  rm -rf "$HOME/.config/Code/User/WorkspaceStorage"/*
  echo "✔ Datos temporales y almacenamiento de áreas de trabajo de VS Code depurados."
else
  echo "• No se detectó el directorio de configuración de VS Code."
fi
echo ""

# 3. Limpieza de historiales de la terminal (Opcional y selectivo)
# Esto limpia el historial de comandos guardados en el disco para la sesión actual
echo "[3/4] Limpiando archivos de historial de la terminal..."
# Vacía el historial de Bash y Zsh si existen
[ -f "$HOME/.bash_history" ] && > "$HOME/.bash_history"
[ -f "$HOME/.zsh_history" ] && > "$HOME/.zsh_history"
history -c
echo "✔ Historial de comandos del sistema blanqueado."
echo ""

# 4. Limpieza del directorio general de caché del usuario
# En image_b0192d.png figura como .cache (372,3 MB)
echo "[4/4] Vaciando la carpeta genérica ~/.cache..."
rm -rf "$HOME/.cache"/*
echo "✔ Carpeta ~/.cache despejada."
echo ""

echo "=== Proceso completado con éxito ==="
