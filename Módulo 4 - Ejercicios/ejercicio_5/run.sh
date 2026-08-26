#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave

set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o sim.out full_adder.sv array_mul.sv tb_array_mul.sv

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
gtkwave tb_array_mul.vcd &