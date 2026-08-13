from fxpmath import Fxp

A = Fxp(-1.75, signed=True, n_word=6, n_frac=4)
B = Fxp(0.9375, signed=True, n_word=8, n_frac=5)

# print(A.info(3))

# La suma de esta forma ya asigna a S la precision optima
S = A + B

# Bits originales
print('A:   ',A.bin(True),'\t|', A(),'\t|', A.val)
print('B:  ', B.bin(True),'\t| ',B(),'\t| ',B.val)

# Aumentar bits de A para que sean iguales los dos sumandos
A.resize(signed=True, n_word=8, n_frac=5)

# Resultado
print()
print('A:  ', A.bin(True), '\t|',A(),'\t|', A.val)
print('B:  ', B.bin(True),'\t| ',B(),'\t| ',B.val)
print('-----------------------------------------')
print('S: ',  S.bin(True),'\t|', S(),'\t|', S.val)
