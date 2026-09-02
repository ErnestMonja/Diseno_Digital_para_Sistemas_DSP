#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave
killall gtkwave

set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o sim.out cordic_vectoring.sv tb_cordic_vectoring.sv

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
gtkwave vectoring.vcd &