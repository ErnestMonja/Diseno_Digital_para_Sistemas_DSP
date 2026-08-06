#!/bin/bash
# run.sh — compila y simula con Icarus Verilog
set -e
cd "$(dirname "$0")"

echo ">>> Compilando con iverilog..."
iverilog -o sim.out tb_reg_ce.v reg_ce.v

echo ">>> Ejecutando con vvp..."
vvp sim.out

echo ""
echo "VCD generado: tb_reg_ce.vcd (abrir con: gtkwave tb_reg_ce.vcd)"
