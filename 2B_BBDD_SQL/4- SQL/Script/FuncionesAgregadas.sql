use tiendaInformatica;
-- Funciones agregadas ----------------------------------------------
/*
Son funciones que operan sobre un conjunto de valores y devuelven un solo valor. 
Se utilizan comúnmente con la cláusula GROUP BY

avg(nombreColumna): valor medio de una columna numérica
min(nombreColumna):  valor mínimo de una columna
max(nombreColumna):  valor máximo de una columna
sum(nombreColumna/expresión):  suma de valores
count(nombreColumna):  cuenta filas no nulas

*/

# Media de los precios de los artículos que tengo en el almacén
select avg(precio)
from articulo;

# Nombre de los articulos cuyo precio es superior a la media
select nomArticulo, precio
from articulo
where precio >(select avg(precio)
              from articulo);      -- funciones agregadas NO se pueden poner en where

# Obtener el precio medio de los artículos por rango de descuento
select 
    case 
        when descuento = 0 then 'Sin descuento'
        when descuento between 1 and 10 then '1-10%'
        when descuento between 11 and 20 then '11-20%'
        else 'Más del 20%'
    end as rangoDescuento,
    round(avg(precio),2) as precioMedio   -- redondeo el real a dos decimales
from articulo
group by rangoDescuento;

# Cuántos clientes han realizado al menos una compra
select  count(distinct idCliente) numeroClientes
from compra;

# Número de artículos distintos que tengo en el almacén
select count(distinct idArticulo)
from articulo; -- NOOOOO

select count(idArticulo)
from articulo; 

# Número total de unidades compradas por cada cliente
select cl.idCliente, cl.nombreC, sum(c.numUnidades), coalesce(sum(c.numUnidades), 0) as totalComprado 
-- sustituye null por cero, para los clientes sin compras
from cliente cl left join compra c on cl.idCliente = c.idCliente
group by cl.idCliente;

# Artículo más caro y más barato comprado por cada cliente, ordenado por el número de cliente
select cl.idCliente, cl.nombreC, min(a.precio) as articuloMasBarato, max(a.precio) as articuloMasCaro
from compra c inner join articulo a on c.idArticulo = a.idArticulo
      inner join cliente cl on c.idCliente = cl.idCliente
group by cl.idCliente
order by idCliente;

# Cliente que ha realizado la compra más reciente
select nombreC, fecCompra
from cliente cl inner join compra c on cl.idCliente=c.idCliente
where fecCompra = (select max(fecCompra) from compra);

# Artículo más caro (recordamos que con limit no estaba bien si habia más de un artículo con el mismo precio)
select nomArticulo, precio
from articulo
where precio =(select max(precio)
               from articulo);

# Nombre del artículo más caro vendido
select nomArticulo, precio
from articulo
where precio =(select max(precio)
               from compra c inner join articulo a on c.idArticulo = a.idArticulo);

#total de unidades compradas por los clientes '011','012', '013' cada año, desde el 2018 al 2020
select idCliente, year(fecCompra), sum(numUnidades)
from compra
where idCliente in ('011', '012', '013')
     and fecCompra between '2018-01-01' and '2020-12-31'
group by idCliente, year(fecCompra);

#Total gastado por cada cliente cada año
select idCliente, year(fecCompra) 'año compra', sum(numUnidades*precio) totalGastado
from compra c inner join articulo a on a.idArticulo=c.idArticulo
group by idCliente, year(fecCompra) -- agrupamos primero por cliente y luego por año
order by idCliente , year(fecCompra) desc; 
  
#Total gastado por cada cliente que ha comprado
select cl.nombreC, sum(c.numUnidades*a.precio) totalGastado
from cliente cl inner join compra c on cl.idCliente=c.idCliente
     inner join articulo a on c.idArticulo=a.idArticulo   
group by c.idCliente;

#Cliente que más ha gastado
select nombreC, sum(numUnidades*precio) totalGastado
from cliente cl inner join compra c on cl.idCliente=c.idCliente
     inner join articulo a on c.idArticulo=a.idArticulo   
group by c.idCliente
having totalGastado = ( select sum(numUnidades*precio) tot
                 from compra c inner join articulo a on c.idArticulo=a.idArticulo
                 group by c.idCliente
                 order by tot desc
                 limit 1);

# Clientes que han comprado al menos una unidad de todos los articulos
-- existentes en almacen
select idCliente
from compra
group by idCliente
having count(distinct idArticulo)= (select count(idArticulo) from articulo);                        





