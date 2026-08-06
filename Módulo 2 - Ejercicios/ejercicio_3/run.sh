#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave

set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o bcd_sim.out bcd_counter.v tb_bcd_counter.v

echo ">>> Ejecutando con vvp..."
vvp bcd_sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
# Abrimos el archivo VCD correcto en segundo plano
gtkwave bcd_counter.vcd &