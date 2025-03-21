use tiendaInformatica;
/*
SELECT [ALL | DISTINCT ]   expresión[, expresión...]
[FROM tablas]
[WHERE condición]
[GROUP BY {nombreColumna} 
[HAVING condición]
[ORDER BY {nombreColumna} [ASC | DESC], ...]
[LIMIT número]
*/
select *
from articulo;

-- calcular la edad de una persona
select TIMESTAMPDIFF(year,'1900-3-28',CURDATE())  annosTranscurridos;

# Operación aritmética
select 3*6+7  as 'operacion aritmetica';  
-- now()-interval 5 year momento actual menos 5 años

select now()-interval 5 year;

select '2024-01-01' - interval 5 month;

-- month(curdate()) mes de la fecha actual
select month(curdate());

select distinct idCliente
from compra;

#Seleccionar clientes mayores de 20 años que viven en la calle Luna:
  
SELECT *   -- con el * salen todos los campos de las tablas que hay en from
FROM cliente
WHERE direccion LIKE '%Luna%'  -- % 0 o varios caracteres _un carácter
	  AND YEAR(CURDATE()) - YEAR(fecNac) > 20;  -- curdate() o current_date()
      
#Seleccionar artículos con un precio entre 50 y 200 y  tengan más de 20 unidades en stock:
SELECT idArticulo, nomArticulo, precio,unidades
FROM articulo
WHERE precio BETWEEN 50 AND 200  -- precio>= 50 and precio<=200
        AND unidades > 20;
        
#Seleccionar clientes nacidos entre 1980 y 1990:
SELECT * 
FROM cliente
WHERE year(fecNac) BETWEEN 1980 AND 1990;

#Seleccionar las características de los artículos Ordenador Sobremesa, Impresora Láser, Router inalámbrico:
SELECT * 
FROM articulo
WHERE nomArticulo IN ('Ordenador Sobremesa', 'Impresora Láser', 'Router inalámbrico');

 # Seleccionar compras realizadas por los clientes '011','012', '013' del 2018 al 2020
 # ordenado por cliente y año:
SELECT * 
FROM compra
WHERE idCliente IN ('011', '012', '013')
     AND fecCompra BETWEEN '2018-01-01' AND '2020-12-31'
order by idCliente desc, year(fecCompra) desc;

SELECT * 
FROM compra
WHERE idCliente IN ('011', '012', '013')
     AND fecCompra BETWEEN '2018-01-01' AND '2020-12-31'
order by idCliente desc, fecCompra desc;






