use tiendaInformatica;
/*
Una vista se define
create view v(nombre de los campos) as 
  <expresión de consulta>;
V es el nombre de la vista, y le puedes asignar nombre a los campos o columnas resultado de la consulta

Una vez definida la vista, su nombre puede utilizarse para referirse a la tabla virtual que la vista genera.

Se utilizan para tres fines:
   Prohibir el acceso a datos confidenciales
   Simplificar la formulación de consultas complejas o repetitivas
   Aumentar la independencia de los programas respecto a los datos

*/
#Gastos de cada  cliente

drop view if exists gastosClientes;
create view gastosClientes(nombreCliente, totalGastado) as 
select nombreC, coalesce(sum(numUnidades*precio),0)
from cliente cl left join compra c on cl.idCliente=c.idCliente
   left  join articulo a on c.idArticulo=a.idArticulo   
group by cl.idCliente;

select *
from gastosClientes;

#  Nombre de los clientes que han realizado gastos superiores a 1000  
Select nombreCliente, totalGastado
from gastosClientes
where totalGastado>1000;

# Cliente que mas se ha gastado
select nombreCliente
from gastosClientes
where totalGastado = (select max(totalGastado) from gastosClientes);

 
 