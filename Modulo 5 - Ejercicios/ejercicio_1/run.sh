#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave
killall gtkwave

set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o sim.out cordic_folded.sv tb_cordic_folded.sv

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
gtkwave cordic.vcd