#!/usr/bin/env python3
from fxpmath import Fxp

# Valores solicitados en el Ejercicio 5
A_val = 6
B_val = -5

print("--- Cálculos de referencia con fxpmath ---")

# A y B son de 4 bits en complemento a 2
A = Fxp(A_val, signed=True, n_word=4, n_frac=0)
B = Fxp(B_val, signed=True, n_word=4, n_frac=0)

# El producto de dos números de 4 bits requiere 8 bits
P = Fxp(A.get_val() * B.get_val(), signed=True, n_word=8, n_frac=0)

print(f"A = {A_val:>3} -> {A.bin()}")
print(f"B = {B_val:>3} -> {B.bin()}")
print(f"P = A * B = {P.get_val()} -> {P.bin()}")