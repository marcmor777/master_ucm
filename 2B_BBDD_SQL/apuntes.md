#1. Introduccion a las Bases de Datos

### 1.1 Sistemas de Gestión de BBDD

Sistema Gestor de BBDD: 
Permite gestionar grandes cantidades de informacion, permite almacenar y recuperar 
la información de forma práctica y eficiente. 
- Permite definir las estructuras para almacenar los datos (tablas etc)
- Debe garantizar la fiabilidad de la información almacenada pase lo que pase

En este modulo veremos las reglas para implementar la BBDD desde problema real
- modelo conceptual: gráfico independiente del RDBMS
- modelo lógico: depende del RDBMS elegido
- modelo físico: es el modelo con el que implementamos la BBDD

Con estos 3 modelos ya podemos implementar nuestra BBDD. La explicación paso a paso de como se implementa una BBDD:
1. Modelo Conceptual: creamos un grafico entidad relacion para visualizar las entidades
que tenemos y como se relacionan. Es un gráfico simple.
2. Modelo Lógico: dependiendo del RDBMS que elijamos, normalmente será un modelo relacional.
Este modelo representa la información en forma de tablas y/o relaciones. En este punto, se aplica la normalización de las tablas (ver 1FN, 2FN, 3FN)
3. Implementación: consiste en plasmar estos modelos teóricos en un modelo físico SQL. Con un RDBMS como puede ser 
mySql workbench.







 
 

