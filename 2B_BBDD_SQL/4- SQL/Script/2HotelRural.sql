/*
       Hoteles rurales
*/

drop database if exists hotelRural;
create database hotelRural;
use hotelRural;
--   ------------ CREACIÓN DE LAS TABLAS -------------------------------
create table pueblo(
    codPueblo int primary key,
    nombreP varchar(50) not null
);

create table actividad(
    codActividad smallint auto_increment primary key,
    nomActividad varchar(50) not null,
    Descripcion varchar (80) not null,
    nivel int check(nivel>=0 and  nivel<=5) not null
);

create table hotel(
    numH int auto_increment primary key,
    nombreHotel varchar(50) not null,
    direccion varchar(50),
    numHab smallint default 0,
    fechaI date,
    idPueblo int,
    foreign key (idPueblo) references pueblo(codPueblo)
    on delete cascade
    on update cascade
);

create table habitacion(
    codHotel int,
    numHab int,
    tipo smallint check(tipo>=1 and tipo<=4) not null,
    banno bool not null,
    precio decimal(6,2)not null,
    primary key(codHotel,numHab),
    foreign key (codHotel) references hotel(numH)
    on delete cascade 
    on update cascade
);    

create table persona(
    codP int auto_increment primary key,
     NIF varchar(9) unique not null,
    nomPersona varchar(15) not null,
    ape1 varchar(15) not null,
    ape2 varchar(15)not null,
    direccion varchar(50),
    codHotel int,
    esContacto bool,
    sueldo decimal(8,2), -- nuevo atributo
    foreign key (codHotel) references hotel(numH)
	on delete cascade
    on update cascade
);

create table telefono(
    numTel varchar(12) primary key,
    codHotel int,
    foreign key (codHotel) references hotel(numH)
	on delete cascade
    on update cascade
); 
     
create table realizaActividad(
     idActividad smallint,
     codHotel int,
     diaSemana int check(diaSemana>=1 and diaSemana<=7),
     primary key(idActividad,codHotel),
     foreign key (codHotel) references hotel(numH)
	  on delete cascade
     on update cascade,
     foreign key (idActividad) references actividad(codActividad)
	on delete cascade
    on update cascade
);

-- trigger para ir sumando habitaciones según las inserto
create trigger NumeroHabitacionesAI after insert
on habitacion
for each row 
update hotel
set numHab=numHab+1
where  new.codHotel=numH;


-- Trigger para restar habitaciones si las borro
create trigger restarHabitacionesAD after delete
on habitacion
for each row
update hotel
set numHab=numHab-1
where old.codHotel=numH;

-- trigger para comprobar si ya existe una persona de contacto en un hotel
DELIMITER $$
CREATE TRIGGER check_contacto BEFORE INSERT ON persona
FOR EACH ROW
BEGIN
  DECLARE num_contactos INT;
   -- antes de insertar los datos de una persona, calculo el número de contactos que tiene el hotel, 
   -- por si acaso decido que la persona sea contacto del hotel dónde trabaja
  SELECT COUNT(*) INTO num_contactos FROM persona
  WHERE codHotel = NEW.codHotel AND esContacto = 1;
 
  IF num_contactos > 0 AND NEW.esContacto = 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe una persona de contacto para este hotel';
  END IF;
END$$
DELIMITER ;

     -- ------INSERTAR DATOS EN LAS TABLAS -------------
insert into pueblo values 
       (1,'Alcobendas'),
       (2,'Pinilla del Valle'),
	   (3,'Lozoya'),
	   (4,'Rascafria'), 
       (5,'Alameda del Valle'),
       (6,'Buitrago del Lozoya'),
       (7,'La Cabrera'),
       (8,'Canencia'),
       (9,'Garganta de los Montes')
	;
insert into actividad(nomActividad,descripcion,nivel) values
    ('Senderismo','Camino Natural Valle del Lozoya',4),
	('Mountain bike','Subida al Nevero', 5),
    ('Piraguismo','Embalse de Lozoya', 4),
	('Ruta en  4x4','Valle del Paular', 1),
    ('Parapente','Puerto de Navafría', 3),
    ('Pinball','Hoya Encavera', 2)
    ;

insert into hotel(nombreHotel,direccion,fechaI,idPueblo) values
    ('Ciclo Lodge', 'calle cuatro calles 2','2020/10/02', 3), -- 1
    ('Los Manzanos', 'calle de la Huerta 7','2023-07-10',4), -- 2
    ('El campanario', 'calle de la Iglesia 11','2021/11/25',4), -- 3
    ('Caserón Tratamara', 'avenida de El Paular 33','2022-01-01',4),  -- 4
    ('El Refugio de la Saúca','calle de los árboles 22','2017-09-17',5), -- 5
    ('El Pajar de Alameda','Avenida de los bueyes 2','2017-05-21',5), -- 6
    ('La Casa de los abuelos','Avenida de la Familia 77','2022/08/07',2), -- 7
    ('La Muralla', 'avenida del Castillo 22','2021/04/14', 6),  -- 8
    ('Sara de Ur','avenida de las cabras 88','2018-03-08',7), -- 9
    ('Huerto de SAn Antoni', 'calle del convento 99','2015-12-25', 7), -- 10
    ('Las Eras','Calle de la trilla 1','2016/02/28',8), -- 11hotel
    ('Canencia Rural','Avenida del Valle 88','2010/07/11',8), -- 12
    ('Hotel Quercus', 'Calle el roble 55','2022/06/12', 9) -- 13
;

INSERT INTO habitacion VALUES(1,1,1,1,20); -- habitacion 1 del hotel 1 con 1 cama
INSERT INTO habitacion VALUES(1,2,1,1,25);
INSERT INTO habitacion VALUES(1,3,1,1,30);
INSERT INTO habitacion VALUES(1,4,1,1,35);

INSERT INTO habitacion VALUES(2,1,2,1,60);-- habitacion 2 con dos camas
INSERT INTO habitacion VALUES(2,2,2,1,60);
INSERT INTO habitacion VALUES(2,3,2,1,60);
INSERT INTO habitacion VALUES(2,4,2,1,60);
INSERT INTO habitacion VALUES(2,5,2,1,65);


INSERT INTO habitacion VALUES(3,1,3,1,90);-- habitación 3 con 3 camas
INSERT INTO habitacion VALUES(3,2,3,1,100);
INSERT INTO habitacion VALUES(3,3,3,1,95);
INSERT INTO habitacion VALUES(3,4,3,1,110);

INSERT INTO habitacion VALUES(4,1,2,1,60);-- habitacion 2 con dos camas
INSERT INTO habitacion VALUES(4,2,2,1,60);
INSERT INTO habitacion VALUES(4,3,2,1,60);
INSERT INTO habitacion VALUES(4,4,2,1,60);
INSERT INTO habitacion VALUES(4,5,2,1,65);

INSERT INTO habitacion VALUES(5,1,3,1,90);-- habitación 3 con 3 camas
INSERT INTO habitacion VALUES(5,2,3,1,100);
INSERT INTO habitacion VALUES(5,3,3,1,95);
INSERT INTO habitacion VALUES(5,4,3,1,110);
INSERT INTO habitacion VALUES(6,1,3,1,100);

INSERT INTO habitacion VALUES(6,2,3,1,125);
INSERT INTO habitacion VALUES(6,3,3,1,100);
INSERT INTO habitacion VALUES(6,4,3,1,100);

INSERT INTO habitacion VALUES(7,1,3,1,100);
INSERT INTO habitacion VALUES(7,2,3,1,125);
INSERT INTO habitacion VALUES(7,3,3,1,100);
INSERT INTO habitacion VALUES(7,4,3,1,100);

INSERT INTO habitacion VALUES(8,1,3,1,100);
INSERT INTO habitacion VALUES(8,2,3,1,125);
INSERT INTO habitacion VALUES(8,3,3,1,100);
INSERT INTO habitacion VALUES(8,4,3,1,140);

INSERT INTO habitacion VALUES(9,1,1,0,50);
INSERT INTO habitacion VALUES(9,2,2,1,60);
INSERT INTO habitacion VALUES(9,3,3,1,70);
INSERT INTO habitacion VALUES(9,4,4,1,80);

INSERT INTO habitacion VALUES(10,1,3,1,40);
INSERT INTO habitacion VALUES(10,2,4,1,50);
INSERT INTO habitacion VALUES(10,3,2,0,80);
INSERT INTO habitacion VALUES(10,4,1,1,30);
INSERT INTO habitacion VALUES(10,5,2,1,35);

INSERT INTO habitacion VALUES(11,1,2,1,85);
INSERT INTO habitacion VALUES(11,2,2,1,85);
INSERT INTO habitacion VALUES(11,3,2,1,85);
INSERT INTO habitacion VALUES(11,4,3,1,100);
INSERT INTO habitacion VALUES(11,5,1,0,35);

INSERT INTO habitacion VALUES(12,1,1,0,20);
INSERT INTO habitacion VALUES(12,2,1,1,25);
INSERT INTO habitacion VALUES(12,3,1,1,30);
INSERT INTO habitacion VALUES(12,4,1,1,35);

INSERT INTO habitacion VALUES(13,1,1,1,70);
INSERT INTO habitacion VALUES(13,2,1,1,40);
INSERT INTO habitacion VALUES(13,3,1,1,90);
INSERT INTO habitacion VALUES(13,4,1,1,65);

INSERT INTO persona(NIF,nomPersona, ape1,ape2,direccion,codHotel,esContacto,sueldo) VALUES
('18123456A', 'Angela', 'Callejo','Garcia','Juan Martin 11 ',1,1,1100), -- 1
('28345684L', 'Loreto', 'Borja','Callejo', 'Luna 4 ',1,0,1000), -- 2
('38345300T', 'Torcuato', 'Arribas','Alonso','Ermita 6 ', 1,0,1000), -- 3
('48334455A', 'Albino', 'Paciencia','Riomoros','Sarria 2 ',1,0,1000), -- 4
('58000111Y', 'Yolanda', 'Barahona','Garcia ', 'Arturo Soria 24',2,1,1200), -- 5
('67434343I', 'Isabel', 'Garcia','Garcia ','Clavel 5 ',3,0,1000), -- 6
('71876987C', 'Clara', 'Alamo','Sanz','Travesia Luna 11 ',3,0,1000), -- 7
('80001100V', 'Valentin', 'Riomoros','Borja ','Manchester 25 ',3,1,1200), -- 8
('90321321J', 'Juan Antonio', 'Sanz','Garcia','Cercona 24', 4,1,1200), -- 9
('10779900L', 'Lucas', 'Gonzalez','Arribas','Lavaderos 34 ',4,0,1000), -- 10
('11000011E', 'Eustaquia', 'Alonso','Montero','Nueces 5 ',5,1,1200), -- 11
('12112277L', 'Luis', 'Montero','Riomoros','Eras 10 ',5,0,1000), -- 12
('13123462A', 'Angel', 'Riocal','Garcia','Las Escuelas',6,1,1200), -- 13
('14123400M', 'Maribel', 'Calle','Alonso','Travesia del Rio 9', 6,0,1000), -- 14
('16123420P', 'Petunia', 'Rosada','Álvarez','Campo florido 22 ', 7,0,1000), -- 15
('17100420J', 'Dominga', 'Requejo','Sánchez','Desconocida 6 ', 7,0,1000), -- 16
('18120020J', 'Jose Luis', 'Revoltoso','Riocal','Pensamiento 56 ',7,1,1200), -- 17
('19123420J', 'Josete', 'Mas','Sedol','Rio pedregoso 16 ',8,1,1200), -- 18
('23274912W', 'Vinicius', 'Mato', 'Duro','Poblados 21',13,0,1100),
('11986431Q', 'Rodrigo', 'Caravajal','Fernández','Fuencarral 17', 13,0,1250),
('43751912T', 'Fernando', 'Botas', 'Álvarez','Torrelaguna 80',13,1,1550),
('32019412Y', 'Beatriz', 'Galindo','Palancar','Ramón y Cajal 35',13,0,925),
('61313436A', 'Angela', 'Amor','Aranda','Aranjuez 1',9,1,1111),
('61313436B', 'Beatriz', 'Borja','Berguilli', 'Badajoz 2',9,0,2222),
('61313436C', 'Carlos', 'Cortes','Cuquerella','Condado 3', 9,0,3333),
('61313436D', 'Diego', 'Diez','Duncan',' Donoso 6 ', 9,0,4444),
('47412078V', 'Aurora', 'Peréz','Ruíz','Camino a Badajoz 10 ',10,0,1000),
('18765820V', 'Carlos', 'López','Hurtado','Anacarado 12 ',11,0,980),
('45698520R', 'Amanda', 'Martín','Martínez','Rio perdido 23 ',12,0,990),
('32078521C', 'Lucía', 'Sanz','Pedrerol','Jazmín 15 ',13,0,1000),
("1234567A", "Ana", "Martin", "Rosal", "c/Alonso", 12, 1, 1500),
("7654321B","Luis", "Fernández", "García", "c/Santo", 12, 0, 400),
("3245687C", "María", "Muñoz", "Ra", "c/filipino", 12, 0, 675),
("8325649D", "Carlos", "Doriam", "Velta", "c/burgo", 12, 0, 1000),
('713437M', 'Ivan', 'Corazon', 'Lopez', 'Donoso Cortes 5', 3, 0, 1250),
('32783947X', 'Andres', 'Moncanut', 'Lago', 'Avenida Virginio 23', 3, 0, 1100),
('12829342S', 'Gonzalo', 'Ballestero', 'Martinez', 'Tutor 69', 3, 0, 1200),
('18293371Q', 'Jimena', 'Martinez', 'Burgos', 'Afueras a Valverde 11', 3, 0, 1250),
('32971209M', 'Ana', 'Mena', 'Rojas', 'Estepona City 15', 11, 1, 2500),
('21872187X', 'Taylor', 'Alison', 'Swift', 'Evermore 13', 11, 0, 2000),
('14982132K', 'Aitana', 'Ocaña', 'Morales', 'San Jacobo 4', 11, 0, 3000),
('43546698A', 'Amaia', 'Romero', 'Arbizu', 'Paco de Lucia 23', 11, 0, 1000),
('06526112R', 'Andrea', 'Sánchez','Sánchez','calle de la Huerta 7',2,0,1300),
('69532666T', 'Maria Belen', 'Gonzalez','Esteban','avenida del Castillo 22',8,0,1200),
('79122868F', 'Carlos', 'Fernández','Gil','Avenida del Valle 88 ',12,0,1000),
('19228643K', 'Andres', 'Riofrio','Diaz','Avenida del Valle 88',12,0,1100),
('45689204D', 'Marina','Perez','Martín', 'calle Fiestas Populares 7',8, 0, 1100) ,
('89752209F', 'Isabel' , 'Arusas' , 'Gómez', 'avenida Residente 10', 8, 0, 1500) ,
('52575658T', 'Benito' ,'Calamaro','Rosal', 'calle Huertas 6' , 8 ,0, 1100) ,
('45673219P', 'Gemma' , 'Méndez' , 'López' , 'calle ciudad de Roma', 8, 0, 2000) ,
('88421857S', 'Óscar', 'Cardo' , 'Diez', 'avenida Juan 23' , 8, 0, 1000),
('11152367A', 'Ángela', 'Lomas', 'Anglada', 'Cartagena 4', 2, 0, 1200),
('11234367B', 'Mónica', 'González', 'de Pablo', 'Arturo Soria 123', 8, 0, 1100),
('19987345D', 'Pepe', 'Pérez', 'González', ' Francisco de Sales 1', 10, 1, 1000),
('99887766F', 'Daniel', 'Fernández ', 'Fernández', 'Avenida de Logroño 33', 11, 0, 1300),
('23234545G', 'Isabel', 'Nuñez', 'Martín', 'Principe de Vergara 67', 11, 0, 1200),
('77777777H', 'Juan', 'Martinez', 'Rodriguez', 'Brezos 12', 12, 0, 1000),
('12125638J', 'Lucía', 'Ramos', 'González', 'Corazón de María 6', 12, 0, 1100),
('23178907D', 'Juan', 'Ortiz', 'González', 'Guzmán el Bueno 48', 13, 0, 1300),
('24456787R', 'Carmen', 'Díaz', 'Alonso', 'Vicente Aleixandre 5', 13, 0, 1000);

insert into telefono values 
     (1111,1),
     (111111,1),
     (2222,2),
     (22222,2),
     (222222,2),
     (3333,3),
     (333,3),
     (4444,4),
     (5555,5),
     (555,5),
     (55555,5),
     (6666,6),
     (7777,7),
     (8888,8),
     (9999,9),
     (101010,10),
     (110011,11),
     (121212,12),
     (1212,12),
     (131313,13),
     (1313,13),
     (13131313,13);
     
 
INSERT INTO realizaActividad VALUES (1,1,1);
INSERT INTO realizaActividad VALUES (2,2,2);
INSERT INTO realizaActividad VALUES (3,3,4);
INSERT INTO realizaActividad VALUES (4,3,7);
INSERT INTO realizaActividad VALUES (4,4,6);
INSERT INTO realizaActividad VALUES (1,5,5);
INSERT INTO realizaActividad VALUES (3,5,5);
INSERT INTO realizaActividad VALUES (2,3,1);
INSERT INTO realizaActividad VALUES (2,4,6);
INSERT INTO realizaActividad VALUES (1,13,2);
INSERT INTO realizaActividad VALUES (4,2,4);
INSERT INTO realizaActividad VALUES (1,3,5);
INSERT INTO realizaActividad VALUES (3,1,5);  

--  Puedes realizar las siguientes consultas
-- 1. Crea una vista con el código del hotel, el nombre del hotel, los empleados, ordenados por el nombre del hotel

-- 2. Nombre hotel que tiene más habitaciones

-- 3. Número de empleados por hotel (con nombre)

-- 4. Hotel con más empleados
-- 5. Número de hoteles por pueblo
-- 6. Nombre de los hoteles que tiene más de 3 empleados, >3

-- 7. Hotel que ha realizado todas las actividades

-- 8. Años que llevan abiertos los hoteles
