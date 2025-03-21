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


