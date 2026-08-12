#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave

set -e
cd "$(dirname "$0")"

echo ">>> Generando benchmark con Python (fxpmath)..."
python3 gen_vectors.py
echo ""

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o sim.out booth.v tb_booth.v

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
gtkwave booth.vcd                           # Abrimos el archivo VCD. 