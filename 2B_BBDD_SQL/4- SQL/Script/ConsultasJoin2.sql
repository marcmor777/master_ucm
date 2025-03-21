use tiendaInformatica;
#Nombre de los clientes que han comprado los artículos '0001','0002' y '0003' en los años 2019 y 2020 y
--  que tienen más de 30 años, ordenado alfabéticamente por el nombre del cliente:

select cl.nombreC, cl.direccion, cl.telefono, cl.fecNac, cl.email
from cliente cl inner join compra c on c.idCliente = cl.idCliente
where c.idArticulo in ('0001', '0002', '0003')
      and c.fecCompra between '2019-01-01' and '2020-12-31'
      and year(curdate()) - year(cl.fecNac) > 30
order by cl.nombre;

#Nombre de los artículos comprados por clientes mayores de 18 años cuyo nombre empieza por A y el artículo comprado  no tiene descuento
select a.idarticulo, a.nomArticulo, a.precio, a.unidades, a.descuento, a.precioFinal
from articulo a inner join compra c on a.idarticulo = c.idarticulo
	 inner join cliente cl on cl.idcliente = c.idcliente
where cl.nombreC like 'a%' and a.descuento=0 and year(current_date())- year(cl.fecNac) >18;

# Máximo número de unidades de un artículo que tengo en el almacén
select  unidades
from articulo
order by unidades desc
limit 1;

# nombre del articulo del que tengo más unidades
select  nomArticulo, unidades
from articulo
order by unidades desc
limit 1;  -- ¡OJO! porque si tengo más de dos artículos con el mismo número de unidades sólo sale uno

# Nombre de los ARTICULOS que tienen mas unidades en almacen que el articulo '0001'
select a2.nomArticulo, a2.unidades, a1.unidades
from articulo a1, articulo a2
where a2.unidades > a1.unidades and a1.idArticulo='0001';

#  Nombre Cliente que sólo han comprado altavoces
select cl.nombreC, c.fecCompra
from cliente cl inner join compra c on cl.idCliente=c.idCliente
     inner join articulo a on c.idArticulo=a.idArticulo    
where a.nomArticulo like '%altavoz%'   -- caracteres comodín seran % 0 o mas letras, _ sólo es una letra
      and cl.idCliente not  in (select c.idCliente
                         from articulo a inner join compra c on a.idArticulo=c.idArticulo
                         where a.nomArticulo not like  '%altavoz%');





