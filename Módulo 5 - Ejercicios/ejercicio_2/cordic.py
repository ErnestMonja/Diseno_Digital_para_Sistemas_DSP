import numpy as np
from fxpmath import Fxp

N = 14 # Iteraciones
tita = -37.0653 # Grados

i = np.arange(N)
tita_rad = tita * np.pi / 180
tita_lut = np.atan(1/2**(i)) # rad
tita_lut_fix = Fxp(tita_lut, signed=True, n_word=16, n_frac=14)

# Crear archivo para la LUT del arctan
with open('05_Circuitos_Aritmeticos_II/ej2/arctan.mem', 'w') as file:
    for value in tita_lut_fix.val:
        file.write(f'{value:04X}\n')    # 04X: 4 digitos hexa

k = 1
for i in range(N):
    k = k * np.sqrt(1 + 1 / (2**(2*i)))

k_fix = Fxp(k, signed=True, n_word=16, n_frac=14)
print()
print("K float:", k)
print("K S(16,14):", k_fix.val)

x = 1/k
y = 0
z = tita_rad

x_fix = Fxp(x, signed=True, n_word=16, n_frac=14)
y_fix = Fxp(y, signed=True, n_word=16, n_frac=14)
z_fix = Fxp(z, signed=True, n_word=16, n_frac=14)

print()
print("-- Valores Iniciales --")
print("x: ", x_fix, "\t (", x_fix.val,")")
print("y: ", y_fix, "\t (", y_fix.val,")")
print("z: ", z_fix, "\t (", z_fix.val,")")

def cordic(x_i,y_i,z_i):
    x = Fxp(signed=True, n_word=16, n_frac=14)
    y = Fxp(signed=True, n_word=16, n_frac=14)
    z = Fxp(signed=True, n_word=16, n_frac=14)
    xs = Fxp(signed=True, n_word=16, n_frac=14)
    ys = Fxp(signed=True, n_word=16, n_frac=14)

    x(x_i)
    y(y_i)
    z(z_i)
    for i in range(N):
        # print("x:", x.val, "\t y:", y.val, "\t z:", z.val)
        xs(y * 2**(-i))
        ys(x * 2**(-i))
        if z <= 0:
            x(x + xs)
            y(y - ys)
            z(z + tita_lut_fix[i])
        else:
            x(x - xs)
            y(y + ys)
            z(z - tita_lut_fix[i])

    return x,y,z

x_fix, y_fix, z_fix = cordic(x_fix, y_fix, z_fix)

print()
print("-- Valores Finales --")
print("x: ", x_fix, "\t (", x_fix.val,")")
print("y: ", y_fix, "\t (", y_fix.val,")")
print("z: ", z_fix, "\t (", z_fix.val,")\n")

x = 1/k
y = 0
M = 10

x_i = Fxp(x, signed=True, n_word=16, n_frac=14)
y_i = Fxp(y, signed=True, n_word=16, n_frac=14)
z_i = Fxp(np.array([0]*M), signed=True, n_word=16, n_frac=14)
x_o = Fxp(np.array([0]*M), signed=True, n_word=16, n_frac=14)
y_o = Fxp(np.array([0]*M), signed=True, n_word=16, n_frac=14)
z_o = Fxp(np.array([0]*M), signed=True, n_word=16, n_frac=14)

x_i(1/k)
y_i(0)
z_i(np.random.uniform(-90,90,M) * np.pi / 180)

# M casos random
for n in range(M):
    x_o[n], y_o[n], z_o[n] = cordic(x_i, y_i, z_i[n])
    print("z_i:", z_i[n].val, "\tx_o:", x_o[n].val, "\ty_o:", y_o[n].val, "\tz_o:", z_o[n].val)
    
z_i_raw = np.asarray(z_i.raw(), dtype=np.int64) & 0xFFFF
x_o_raw = np.asarray(x_o.raw(), dtype=np.int64) & 0xFFFF
y_o_raw = np.asarray(y_o.raw(), dtype=np.int64) & 0xFFFF
z_o_raw = np.asarray(z_o.raw(), dtype=np.int64) & 0xFFFF

# Crear archivo para el testbench
with open('05_Circuitos_Aritmeticos_II/ej2/z_i.mem', 'w') as file:
    for value in z_i_raw:
        file.write(f'{value:04X}\n')
with open('05_Circuitos_Aritmeticos_II/ej2/x_o.mem', 'w') as file:
    for value in x_o_raw:
        file.write(f'{value:04X}\n')
with open('05_Circuitos_Aritmeticos_II/ej2/y_o.mem', 'w') as file:
    for value in y_o_raw:
        file.write(f'{value:04X}\n')
with open('05_Circuitos_Aritmeticos_II/ej2/z_o.mem', 'w') as file:
    for value in z_o_raw:
        file.write(f'{value:04X}\n')