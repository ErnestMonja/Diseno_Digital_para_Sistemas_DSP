from fxpmath import Fxp

# Valores solicitados en el Ejercicio 3
x_val = 5.5625
y_val = 8.75

print("--- Cálculos de referencia con fxpmath ---")

# a) x = 5.5625 en S(10,6) a S(7,3)
x_in = Fxp(x_val, signed=True, n_word=10, n_frac=6)
x_trunc = Fxp(x_val, signed=True, n_word=7, n_frac=3, overflow='wrap', rounding='trunc')
x_round = Fxp(x_val, signed=True, n_word=7, n_frac=3, overflow='wrap', rounding='around')

print(f"x_in (S10.6): {x_in.bin()} -> {x_in.get_val()}")
print(f"x_trunc (S7.3): {x_trunc.bin()} -> {x_trunc.get_val()}")
print(f"x_round (S7.3): {x_round.bin()} -> {x_round.get_val()}")

# b) y = 8.75 en S(11,6) a S(5,3)
y_in = Fxp(y_val, signed=True, n_word=11, n_frac=6)     # Actualizado a n_word=11
y_wrap = Fxp(y_val, signed=True, n_word=5, n_frac=3, overflow='wrap', rounding='trunc')
y_sat = Fxp(y_val, signed=True, n_word=5, n_frac=3, overflow='saturate', rounding='trunc')

print(f"\ny_in (S11.6): {y_in.bin()} -> {y_in.get_val()}")
print(f"y_wrap (S5.3): {y_wrap.bin()} -> {y_wrap.get_val()}")
print(f"y_sat  (S5.3): {y_sat.bin()} -> {y_sat.get_val()}")