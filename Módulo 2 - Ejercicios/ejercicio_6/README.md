## Análisis del Bug

Se trata de una ALU donde uno de los valores del selector de función no realiza ningún cambio, es decir, la salida no está asignada en este valor. Esto provoca que la síntesis infiera un latch, es decir, una lógica combinacional que almacene un dato. Los latches no están permitidos a la hora de diseñar, ya que pueden traer consecuencias como la metaestabilidad.

Se comparó este código con otros dos que solucionan el latch, mediante un testbench que inyecta 64 casos de entrada para cada valor del selector. La salida muestra:

```
a = 3d  b = 3e  op = 2  y(latch) = 3c  y(default) = 3c  y(pre-assign) = 3c
a = 3e  b = 3f  op = 2  y(latch) = 3e  y(default) = 3e  y(pre-assign) = 3e
a = 3f  b = 40  op = 2  y(latch) = 00  y(default) = 00  y(pre-assign) = 00
a = 00  b = 01  op = 3  y(latch) = 00  y(default) = 01  y(pre-assign) = 01
a = 01  b = 02  op = 3  y(latch) = 00  y(default) = 03  y(pre-assign) = 03
a = 02  b = 03  op = 3  y(latch) = 00  y(default) = 03  y(pre-assign) = 03
```

Se observa que el último valor que adquiere `y` es 00, y cuando el selector `op` cambia al valor sin asignar, `y` se mantiene almacenado como `00`. Al no haber declarado ninguna lógica de reloj, esto implica en la generación de un latch. Este fenómeno no ocurre así con los otros dos casos, donde `y` sí tiene asignado un valor para ese selector.