from fxpmath import Fxp
import numpy as np

K = Fxp(23, False, 6, 0)
X = Fxp(np.arange(-8,8), True, 4, 0)
Y0 = Fxp(None, True, 9, 0)
Y1 = Fxp(None, True, 10, 0)

print('K Estandar: 0  1  0  1  1  1')
print('     K CSD: 1  0 -1  0  0 -1')

for i in np.arange(-8,8):
    # Estandar
    Y0(((X[i] << 4) + (X[i] << 2) + (X[i] << 1) + X[i]) ())
    # CSD
    Y1(((X[i] << 5) - (X[i] << 3) - X[i]) ())

    print('X:',X[i].bin(),' (',X[i],')\t| Y (est):',Y0.bin(),' (',Y0,')   \t| Y (csd):',Y1.bin(),' (',Y1,')')