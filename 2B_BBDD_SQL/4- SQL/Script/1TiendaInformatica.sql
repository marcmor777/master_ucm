DROP DATABASE IF EXISTS tiendaInformatica;
CREATE DATABASE TiendaInformatica;
USE tiendaInformatica;
/*
CREATE TABLE r (
             A1 D1, 
             A2 D2,  
             ...,
             An Dn,
	        (restricción de integridad 1),
            ..., restricción de integridadk)
                         );
r es el nombre de la relación o tabla
Cada Ai  es un atributo del esquema de relación  o tabla r 
Di es el tipo del dominio del atributo Ai
*/
CREATE TABLE cliente (
   idCliente  varchar(3),
   nombreC varchar(40) not null,
   direccion varchar(40) not null,
   telefono  varchar(9) not null check(telefono REGEXP '^[0-9]{9}$'),
   fecNac date not null,
   email varchar(50) check (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
   PRIMARY KEY(idCliente)
);
CREATE TABLE articulo (
   idArticulo  varchar(4) primary key,
   nomArticulo   varchar(40) not null,
   precio    numeric(6,2) not null,
   unidades    integer not null,
   descuento numeric(5,2) DEFAULT 0,
   precioFinal numeric(7,2) default 0 --  o default null , o DEFAULT (PRECIO-PRECIO*(DESCUENTO/100)) o crear un trigger para rellenarlo 
 );

 CREATE TABLE compra (
   idCliente     varchar(3),
   idArticulo     varchar(4),
   fecCompra  date  NOT NULL,
   numUnidades   integer not null check( numUnidades >0),
   PRIMARY KEY(idCliente, idArticulo,fecCompra),
   FOREIGN KEY(idCliente) REFERENCES cliente(idCliente) ON DELETE cascade ON UPDATE CASCADE,   
   FOREIGN KEY(idArticulo) REFERENCES articulo(idArticulo) ON DELETE cascade on UPDATE CASCADE
   );
  
 /*
CREATE TABLE compra (
   idCompra int primary key,
   idCliente    varchar(3),
   idArticulo   varchar(4),
   fecCompra  date  NOT NULL,
   numUnidades   integer not null check( numUnidades >0),
   unique  KEY(idCliente, idArticulo,fecCompra),
   FOREIGN KEY(idCliente) REFERENCES cliente(CodCliente) ON DELETE cascade ON UPDATE CASCADE,   
   FOREIGN KEY(idArticulo) REFERENCES articulo(codArticulo) ON DELETE cascade on UPDATE CASCADE
   );
*/

INSERT INTO cliente 
		VALUES  ('008', 'Torcuato Montero', 'Rio Duero 14', '937846308', '1980-05-14', 'torcuato.montero@example.com'),
				('009', 'Asuncion Rodríguez', 'Pez 14', '914565308', '1975-08-22', 'asuncion.rodriguez@example.com'),
				('011', 'Angela Callejo', 'Pedro Villar 330', '914849303', '1988-11-30', 'angela.callejo@example.com'),
				('012', 'Maribel Riocal', 'Luna 11', '914394943', '2000-03-15', 'maribel.riocal@example.com'),
				('013', 'Juan Antonio Sanz', 'Clavel 21', '915656501', '1982-07-19', 'juan.sanz@example.com'),
				('014', 'Clara Garcia', 'Cercona 57', '913389307', '1995-12-05', 'clara.garcia@example.com'),
				('015', 'Isabel Sanrio', 'Travesia del rio 14', '917845308', '2024-09-10', 'isabel.sanrio@example.com'),
                ('016', 'Eugenio Arribas', 'Tinajas 14', '917845308', '1978-04-25', 'eugenio.arribas@example.com'),
                ('017', 'Luis Fernández', 'Calle Mayor 10', '912345678', '1992-06-18', 'luis.fernandez@example.com'),
                ('018', 'Marta López', 'Avenida de la Paz 45', '912345679', '1993-02-14', 'marta.lopez@example.com'),
				('019', 'Carlos Martínez', 'Calle del Sol 22', '913456789', '1987-10-05', 'carlos.martinez@example.com'),
				('020', 'Lucía Gómez', 'Plaza Mayor 3', '914567890', '1991-04-23', 'lucia.gomez@example.com'),
				('021', 'Pedro López', 'Calle Luna 8', '915678901', '1985-07-12', 'pedro.lopez@example.com'),
				('022', 'Ana Torres', 'Calle Estrella 19', '916789012', '1990-11-30', 'ana.torres@example.com');
				
INSERT INTO articulo(idArticulo, nomArticulo,precio,unidades) 
             VALUES ('0001', 'Ordenador Sobremesa', 600, 12),
                    ('0002', 'Ordenador Portátil',1000,  6),
                    ('0003', 'Tarjeta Red',20, 50)  ,
					('0004', 'Impresora Láser',200,  4),
                    ('0005', 'Ratón USB', 7, 50),
                    ('0006', 'Monitor TFT', 250, 10),
                    ('0007', 'Router inalámbrico', 100, 30),
					('0008', 'altavoz', 100,30),
                    ('0009', 'Teclado Mecánico', 50.00, 40),
					('0010', 'Disco Duro Externo', 80.00, 25),
					('0011', 'Memoria USB 64GB', 15.00, 100),
					('0012', 'Cámara Web HD', 45.00, 20),
					('0013', 'Auriculares Bluetooth', 60.00, 35);


INSERT INTO compra 
          VALUES('011', '0001', '2016/10/06', 1),
				('011', '0005', '2017/10/06', 2),
				('012', '0002', '2019/11/06', 1),
				('012', '0003', '2018/11/06', 3),
				('012', '0001', '2018/11/06', 3),
				('012', '0004', '2018/11/06', 3),
				('012', '0005', '2022/11/06', 3),
				('012', '0006', '2018/12/06', 3),
				('012', '0007', '2018/11/06', 3),
				('012', '0008', '2018/12/06', 3),
				('013', '0006', '2020/10/06', 2),
				('013', '0003', '2017/10/06', 2),
				('015', '0004', '2003/11/06', 1),
				('015', '0002', '2019/12/06', 1),
				('015', '0007', '2020/11/06', 8),
                ('014', '0009', '2025/05/15', 1),
				('014', '0010', '2021/06/20', 2),
				('016', '0011', '2025/07/25', 5),
				('017', '0012', '2021/08/30', 1),
				('018', '0013', '2023/09/10', 3),
				('019', '0008', '2021/10/05', 2);


/*
SELECT [ALL | DISTINCT ]   expresión[, expresión...]
[FROM tablas]
[WHERE condición]
[GROUP BY {nombreColumna} 
[HAVING condición]
[ORDER BY {nombreColumna} [ASC | DESC], ...]
[LIMIT número]
*/
-- ---------- Algunas funciones ----------------------------------------------
-- calcular la edad de una persona
select TIMESTAMPDIFF(year,'1987-2-21',CURDATE())  annosTranscurridos;

# Operación aritmética
select 3*6+7  as 'operacion aritmetica';  
-- now()-interval 5 year momento actual menos 5 años

select now()-interval 5 year;

select '2024-01-01' - interval 5 month;

-- month(curdate()) mes de la fecha actual
select month(curdate());

select distinct idCliente
from compra;

--  Consultas una tabla -------------------------------------------------------------------------
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

-- Consultas con más de una tabla ---------------------------------------------------

-- Nombre de los clientes que han comprado alguna vez (batiburrillo)
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
                        from compra); -- más ineficiente, intentar evitar pensar de esta forma
                        

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


