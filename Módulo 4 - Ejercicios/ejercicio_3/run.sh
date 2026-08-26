#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave

set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o sim.out rca4.sv csla16.sv tb_csla.sv

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
gtkwave csla.vcd