#!/bin/bash
# run.sh — compila y simula con Icarus Verilog
set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o sim.out tb_mul_seq.sv mul_seq.sv

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo "VCD generado. Abrir con: gtkwave tb_mul_seq.vcd"
