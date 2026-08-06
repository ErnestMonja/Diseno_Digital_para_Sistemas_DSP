#!/bin/bash
# run.sh - compila, simula con Icarus Verilog y abre GTKWave

set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -g2012 -o pipeline_sim.out pipeline_3stage.v tb_pipeline.v

echo ">>> Ejecutando con vvp..."
vvp pipeline_sim.out

echo ""
echo ">>> Abriendo las ondas en GTKWave..."
# Abrimos el archivo VCD generado en el testbench en segundo plano
gtkwave pipeline.vcd &