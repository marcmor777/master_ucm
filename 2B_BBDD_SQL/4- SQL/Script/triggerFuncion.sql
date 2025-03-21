# Comprobar restricciones de entrada
drop database if exists ejemploTriggers;
create database ejemploTriggers;
use ejemploTriggers;
-- ---------------------TABLAS -----------------------------------------------
create table persona(
   codP  int AUTO_INCREMENT primary key,
   dni varchar(9),
   nombreP varchar(50),
   fechaNac date,
   edad int 
   );
   -- ---------------------------------------------------------------------------
 
#Función que dado un dni devuelve la letra correspondiente, la división entera del D.N.I. por 23.  
    DROP FUNCTION IF EXISTS letraDNI;
    delimiter //
   create function letraDNI (dniF varchar(9)) 
   returns char(1)
    deterministic
    begin
      return substr('TRWAGMYFPDXBNJZSQVHLCKE',mod(dniF,23)+1,1);
	end//
#El trigger se activa antes de insertar en la tabla persona, comprueba si el dni tiene letra y si no la tiene, 
# llamará a la función para concatenar la letra al número de dni 
    
  delimiter //
 create trigger personaBI before insert on persona for each row
  begin 
    if right(new.dni,1) not like '%[a-zA-Z]%'  then 
        set new.dni=concat(new.dni,letraDNI(new.dni));
    end if;
    end //    

insert into persona(dni,nombreP, fechaNac) 
           values ('345650','DNI sin letra, esto en minuscula','2020-10-8');-- Z
select * from persona;