    
#Trigger de eliminación. Cada vez que eliminamos un artículo lo guardamos para tener un histórico de los artículos que hemos tenido.
# Creamos una tabla para guardar la información eliminada

  drop table if exists articuloEliminado;
 CREATE TABLE articuloEliminado (
  e_codArticulo varchar(4) ,
  e_nombreArticulo varchar(40) ,
  e_precio numeric(6,2) not null,
  e_unidades integer not null,
  fechaE datetime
  );
  
  
   delimiter //
  drop trigger if exists eliminaArticuloAD;
 create trigger eliminaArticuloAD after delete 
 on articulo 
 for each row
  begin 
    insert into articuloEliminado values (old.idArticulo,old.nomArticulo,old.precio,old.unidades,now());
   end //    
  # DELETE FROM `tiendainformatica`.`articulo` WHERE (`idArticulo` = '0001');
 
    
#  Guardar los cambios de precio de los artículos, para llevar el control de las variaciones en el precio de los artículos
create table cambioPrecio(
   codArticulo varchar(4),
   precioOld decimal(6,2),
   precioNew decimal(6,2),
   usuario varchar(50),
   fecCambio datetime
);
-- drop trigger guardarPreciosAU;
delimiter //
create trigger guardarPreciosAU after update
on articulo
for each row 
begin 
if old.precio <> new.precio then
   insert into cambioPrecio
       values (old.idArticulo, old.precio,new.precio, user(),now());
end if;
end;
//

