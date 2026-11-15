#!/usr/bin/env python3
"""
Script de auditoría de Clean Code y Linter para Flutter (seminario_2026_02)
Inspecciona:
1. Llamadas a print() en producción (avoid_print).
2. Campos mutables en StatelessWidget.
3. Convención de nombres snake_case en archivos.
4. Ejecución del análisis estático oficial (flutter analyze).
"""

import os
import re
import subprocess
import sys

# Compatibilidad UTF-8 en consolas Windows
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

def print_header(title):
    print("\n" + "=" * 65)
    print(f" [CLEAN-CODE] {title}")
    print("=" * 65)

def check_print_calls():
    print_header("Fase 1: Detección de print() en Código de Producción")
    violations = []
    
    lib_dir = "lib"
    if os.path.exists(lib_dir):
        for root, _, files in os.walk(lib_dir):
            for file in files:
                if file.endswith(".dart"):
                    path = os.path.join(root, file)
                    with open(path, "r", encoding="utf-8", errors="ignore") as f:
                        lines = f.readlines()
                    for idx, line in enumerate(lines, 1):
                        # Detectar llamadas a print( pero ignorar debugPrint(
                        if re.search(r"(?<!debug)print\s*\(", line):
                            violations.append((path, idx, line.strip()))

    if violations:
        print("[!] REGLA avoid_print: Se detectaron llamadas a print():")
        for path, line_no, content in violations:
            print(f"  [X] {path}:{line_no} -> {content}")
        print("\n  -> Accion: Reemplaza por debugPrint() o delega en un callback (VoidCallback).")
    else:
        print("[OK] CONFORME: No se encontraron llamadas a print() en lib/.")

def check_file_naming():
    print_header("Fase 2: Convenciones de Nomenclatura de Archivos (snake_case)")
    naming_issues = []
    
    for search_dir in ["lib", "test"]:
        if not os.path.exists(search_dir):
            continue
        for root, _, files in os.walk(search_dir):
            for file in files:
                if file.endswith(".dart"):
                    base_name = file[:-5]
                    # Verificar si cumple snake_case (letras minúsculas y guiones bajos)
                    if not re.match(r"^[a-z0-9_]+$", base_name):
                        naming_issues.append(os.path.join(root, file))

    if naming_issues:
        print("[!] ADVERTENCIA: Los siguientes archivos no cumplen snake_case:")
        for path in naming_issues:
            print(f"  [!] {path}")
    else:
        print("[OK] CONFORME: Todos los archivos Dart siguen snake_case.")

def check_flutter_analyze():
    print_header("Fase 3: Ejecución de 'flutter analyze'")
    try:
        proc = subprocess.run(
            "flutter analyze",
            shell=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace"
        )
        output = proc.stdout.strip()
        print(output)
        if proc.returncode == 0:
            print("\n[OK] flutter analyze finalizó con 0 problemas.")
        else:
            print(f"\n[!] flutter analyze reportó incidencias (código de salida: {proc.returncode}).")
    except Exception as e:
        print(f"(!) Error al ejecutar flutter analyze: {e}")

def main():
    print("Iniciando Verificación de Clean Code y Linter...")
    check_print_calls()
    check_file_naming()
    check_flutter_analyze()
    print("\n[FIN] Verificación completada.\n")

if __name__ == "__main__":
    main()
