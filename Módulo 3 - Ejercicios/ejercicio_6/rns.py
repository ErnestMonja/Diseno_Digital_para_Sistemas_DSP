from fxpmath import Fxp
import numpy as np

# a = Fxp(14, False, 5, 0)
# b = Fxp(6, False, 4, 0)
x = 14
y = 6
mod = [3,5,7]
x_mod = []
y_mod = []
p_mod = []


for i in range(3):
    x_mod.append(x % mod[i])
    y_mod.append(y % mod[i])

for i in range(3):
    p_mod.append((x_mod[i] * y_mod[i]) % mod[i])

print('X:',x,' | ',x_mod)
print('Y: ',y,' | ',y_mod)
print('P:',x*y,' | ',p_mod)

print('84 % 3 =', 84 % 3)
print('84 % 5 =', 84 % 5)
print('84 % 7 =', 84 % 7)