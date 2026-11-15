#!/usr/bin/env python3
"""
Script de auditoria de arquitectura para Flutter (seminario_2026_02)
Inspecciona:
1. Ultimos 5 commits en Git.
2. Violaciones de Scaffold en lib/pages/ y lib/widgets/.
3. Uso de funciones auxiliares Widget _build vs composicion.
4. Inventario de widgets reutilizables en lib/widgets/.
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

def run_cmd(cmd):
    try:
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, check=True, encoding="utf-8", errors="replace")
        return res.stdout.strip()
    except subprocess.CalledProcessError as e:
        return e.output.strip() if e.output else str(e)
    except Exception as e:
        return str(e)

def print_header(title):
    print("\n" + "=" * 65)
    print(f" [ARCH-AUDIT] {title}")
    print("=" * 65)

def check_recent_commits():
    print_header("Fase 1: Ultimos 5 Commits")
    log_output = run_cmd("git log -n 5 --oneline --stat")
    if log_output:
        print(log_output)
    else:
        print("(!) No fue posible obtener el historial de Git.")

def scan_scaffold_violations():
    print_header("Fase 2: Auditoria de Jerarquia (Scaffolds Anidados)")
    violations = []
    
    restricted_dirs = ["lib/pages", "lib/widgets"]
    for rdir in restricted_dirs:
        if not os.path.exists(rdir):
            continue
        for root, _, files in os.walk(rdir):
            for file in files:
                if file.endswith(".dart"):
                    path = os.path.join(root, file)
                    with open(path, "r", encoding="utf-8", errors="ignore") as f:
                        lines = f.readlines()
                    for idx, line in enumerate(lines, 1):
                        if re.search(r"\bScaffold\s*\(", line):
                            violations.append((path, idx, line.strip()))

    if violations:
        print("[!] VIOLACION CRITICA: Se encontraron Scaffolds en capas prohibidas:")
        for path, line_no, content in violations:
            print(f"  [X] {path}:{line_no} -> {content}")
        print("\n  -> Recordatorio: Solo 'lib/screens/' puede contener Scaffold.")
    else:
        print("[OK] CONFORME: Ninguna Page ni Widget contiene Scaffold anidado.")

def scan_composition_practices():
    print_header("Fase 3: Principio de Composicion vs. Metodos Auxiliares")
    helper_methods = []
    
    lib_dir = "lib"
    if os.path.exists(lib_dir):
        for root, _, files in os.walk(lib_dir):
            for file in files:
                if file.endswith(".dart"):
                    path = os.path.join(root, file)
                    with open(path, "r", encoding="utf-8", errors="ignore") as f:
                        lines = f.readlines()
                    for idx, line in enumerate(lines, 1):
                        # Detectar funciones privadas como Widget _buildSomething()
                        if re.search(r"Widget\s+_[a-zA-Z0-9]+\s*\(", line):
                            helper_methods.append((path, idx, line.strip()))

    if helper_methods:
        print("[*] ADVERTENCIA DE COMPOSICION: Se detectaron metodos auxiliares 'Widget _build...()':")
        for path, line_no, content in helper_methods:
            print(f"  [!] {path}:{line_no} -> {content}")
        print("\n  -> Recomendacion: Extrae estos metodos a StatelessWidget independientes para permitir const y evitar reconstrucciones innecesarias.")
    else:
        print("[OK] CONFORME: No se detectaron metodos auxiliares privados. Buen uso de composicion.")

def scan_reusable_widgets():
    print_header("Fase 4: Catalogo de Widgets Reutilizables")
    widgets_dir = "lib/widgets"
    if os.path.exists(widgets_dir):
        files = [f for f in os.listdir(widgets_dir) if f.endswith(".dart")]
        print(f"Widgets disponibles en {widgets_dir} ({len(files)} encontrados):")
        for f in sorted(files):
            print(f"   - {f}")
    else:
        print("(!) No existe el directorio lib/widgets.")

def main():
    print("Iniciando Auditoria de Arquitectura de Flutter...")
    check_recent_commits()
    scan_scaffold_violations()
    scan_composition_practices()
    scan_reusable_widgets()
    print("\n[FIN] Auditoria finalizada exitosamente.\n")

if __name__ == "__main__":
    main()
