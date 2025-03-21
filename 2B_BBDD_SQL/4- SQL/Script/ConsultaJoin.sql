use tiendaInformatica;
-- Nombre de los clientes que han comprado alguna vez
select nombreC, idArticulo, numUnidades
from compra, cliente
where compra.idCliente=cliente.idCliente;
/*
----- INNER JOIN      LEFT JOIN     RIGHT JOIN  ------------------------
SELECT nombreColumna(s) 
FROM tablaA INNER JOIN tablaB ON tablaA.nombreColumna=tablaB.nombreColumna;

SELECT nombreColumna(s) 
FROM tablaA LEFT JOIN tablaB ON tablaA.nombreColumna=tablaB.nombreColumna;

SELECT nombreColumna(s) 
FROM tablaA RIGTH JOIN tablaB ON tablaA.nombreColumna=tablaB.nombreColumna;

*/

# Nombre de los clientes y código de los artículos que han comprado (también con subconsulta)
select nombreC,idArticulo, fecCompra
from compra c inner join cliente cl on c.idCliente=cl.idCliente;

select nombreC
from cliente
where idCliente in (select idCliente
                    from compra); -- más ineficiente
                    

#Nombre de los clientes y nombre de los artículos que han comprado
select nombreC,nomArticulo, fecCompra
from cliente  cl inner join compra c on c.idCliente=cl.idCliente
     inner join articulo a on a.idArticulo=c.idArticulo
order by nombreC desc  ;


# Nombre de los clientes que no han comprado
select nombreC, cl.idCliente, c.idCliente
from cliente cl left join compra c on c.idCliente=cl.idCliente
where c.idCliente is null;

select nombreC, cl.idCliente, c.idCliente
from compra c right join cliente cl on c.idCliente=cl.idCliente
where c.idCliente is null;

-- Con subconsulta
select nombreC
from cliente
where idCliente not in (select idCliente
                        from compra); -- más ineficiente
                        


