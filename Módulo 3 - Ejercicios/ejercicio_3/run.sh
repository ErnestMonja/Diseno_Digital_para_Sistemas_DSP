#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave
# Cierro GTKwave en caso de que ya este abierto
killall gtkwave

set -e
cd "$(dirname "$0")"

echo ">>> Generando benchmark con Python (fxpmath)..."
python3 gen_vectors.py
echo ""

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o sim.out recorte.v tb_recorte.v

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
# Abrimos el archivo VCD generado en el testbench en segundo plano

gtkwave recorte.vcd