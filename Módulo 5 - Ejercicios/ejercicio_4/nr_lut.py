import numpy as np
from fxpmath import Fxp

# ------ LUT ------

N = 8
y_lut = []
y_lut.append(0.001)
y_lut.append(0.002)
y_lut.append(0.01)
y_lut.append(0.02)
y_lut.append(0.1)
y_lut.append(0.2)
y_lut.append(0.5)
y_lut.append(0.6)

y_fix = Fxp(y_lut, signed=False, n_word=18, n_frac=16)
print(y_fix)

# Crear archivo para la LUT
with open('05_Circuitos_Aritmeticos_II/ej4/lut.mem', 'w') as file:
    for value in y_fix.val:
        file.write(f'{value:05X}\n')    # 05X: 5 digitos hexa