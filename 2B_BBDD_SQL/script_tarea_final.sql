/*
SCRIPT TAREA FINAL.
Asignatura: BBDD SQL
Nombre del Autor: Morales Guamantaqui, José Marcelo
Nombre de la base de datos: empresa_eventos
Fecha: 2025-03-17
*/

/* ------------------------------------------------------------------------------------------------
Definición de la estructura de la base de datos
--------------------------------------------------------------------------------------------------*/
USE Empresa_Eventos;
-- Crear Tabla: ubicacion
CREATE TABLE IF NOT EXISTS ubicacion (
    id_ubicacion INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    direccion VARCHAR(255),
    ciudad_pueblo VARCHAR(255),
    aforo INT,
    precio_alquiler DECIMAL(10, 2),
    caracteristicas TEXT
);
-- Crear Tabla: actividad
CREATE TABLE IF NOT EXISTS actividad (
    id_actividad INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    tipo VARCHAR(50),
    coste DECIMAL(10, 2)
);

-- Crear Tabla: artista
CREATE TABLE IF NOT EXISTS artista (
    id_artista INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    biografia TEXT
);

-- Crear Tabla: asistente
CREATE TABLE IF NOT EXISTS asistente (
    id_asistente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(255),
    email VARCHAR(255)
);


-- Crear Tabla: evento
CREATE TABLE IF NOT EXISTS evento (
    id_evento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    id_ubicacion INT NOT NULL,
    precio_entrada DECIMAL(10, 2),
    fecha DATE,
    hora TIME,
    id_actividad INT NOT NULL,
    FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_actividad) REFERENCES actividad(id_actividad) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Crear Tabla: telefono_asistente
CREATE TABLE IF NOT EXISTS telefono_asistente (
    id_asistente INT NOT NULL,
    numero_telefono VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_asistente) REFERENCES asistente(id_asistente) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_asistente, numero_telefono)
);

-- Crear Tabla: actividad_artista
CREATE TABLE IF NOT EXISTS actividad_artista (
    id_actividad INT NOT NULL,
    id_artista INT NOT NULL,
    cache_artista DECIMAL(10, 2),
    FOREIGN KEY (id_actividad) REFERENCES actividad(id_actividad) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_artista) REFERENCES artista(id_artista) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_actividad, id_artista)
);

-- Crear Tabla: asistencia_evento
CREATE TABLE IF NOT EXISTS asistencia_evento (
    id_asistente INT NOT NULL,
    id_evento INT NOT NULL,
    valoracion INT CHECK (valoracion BETWEEN 0 AND 5),
    FOREIGN KEY (id_asistente) REFERENCES asistente(id_asistente) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_evento) REFERENCES evento(id_evento) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (id_asistente, id_evento)
);


/*-----------------------------------------------------------------------------------------------------------
Trigger: revisa que cada vez que se añade un evento nuevo. Debe tener correspondiente ubicación y actividad.
-------------------------------------------------------------------------------------------------------------*/ 
DELIMITER //

CREATE TRIGGER check_ubicacion_actividad
BEFORE INSERT ON evento
FOR EACH ROW
BEGIN
    -- Declaramos variables para comprobar existencia de claves ajenas.
    DECLARE ubicacion_exists INT;
    DECLARE actividad_exists INT;

    -- Check: si id_ubicacion existe en la tabla ubicacion
    SELECT COUNT(*) INTO ubicacion_exists
    FROM ubicacion
    WHERE id_ubicacion = NEW.id_ubicacion;

    -- Check: si id_actividad existe en la tabla actividad
    SELECT COUNT(*) INTO actividad_exists
    FROM actividad
    WHERE id_actividad = NEW.id_actividad;

    -- Si el id_ubicacion no existe, devolver un mensaje
    IF ubicacion_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Trigger message: el valor de ubicacion_id indicado no existe en la tabla ubicacion.';
    END IF;

    -- Si id_actividad no existe, devolver un mensaje
    IF actividad_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Trigger message: el valor de actividad_id indicado no existe en la tabla actividad.';
    END IF;
END;
// DELIMITER ;

/*------------------------------------------------------------------------------------------------------
Inserción de Datos: se ha hecho siguiendo procedimiento descrito en el documento "Cargar Datos Workbench"
Los archivos CSV están en la carpeta RAW_DATA del directorio Raíz.
-------------------------------------------------------------------------------------------------------*/
SELECT @@GLOBAL.secure_file_priv;
-- Cargamos tabla ACTIVIDAD
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/actividad_raw.csv'
INTO TABLE actividad
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(nombre, tipo, coste);

-- Carga de tabla Ubicacion
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubicacion_raw.csv'
INTO TABLE ubicacion
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(nombre, direccion, ciudad_pueblo, aforo, precio_alquiler, caracteristicas);

-- Carga de tabla Asistente
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/asistente_raw.csv'
INTO TABLE asistente
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(nombre_completo, email);

-- Carga de tabla Artista
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/artista_raw.csv'
INTO TABLE artista
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(nombre, biografia);

-- Carga de tabla Evento
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/evento_raw.csv'
INTO TABLE evento
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
( nombre, id_ubicacion, precio_entrada, fecha,hora,id_actividad);

-- Carga de tabla actividad_artista
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/actividad_artista_raw.csv'
INTO TABLE actividad_artista
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(id_actividad, id_artista, cache_artista);

-- Carga de tabla asistencia_evento
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/asistencia_evento_raw.csv'
INTO TABLE asistencia_evento
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(id_asistente, id_evento, valoracion);

-- Carga de tabla telefono_asistente
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/telefono_asistente_raw.csv'
INTO TABLE telefono_asistente
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(id_asistente, numero_telefono);

-- Intentamos insertar un evento para probar el trigger
Insert into evento (nombre, id_ubicacion, precio_entrada, fecha, hora, id_actividad)
VALUES ('test_event', 33393, 33, '2025-12-01', '10:00', 6666);
-- El trigger funciona devolviendo un mensaje claro



/*------------------------------------------------------------------------------------------------------
Consultas, modificaciones, borrados y vistas con enunciado
-------------------------------------------------------------------------------------------------------*/
-- VISTA: creamos la vista que enlaza las tablas: actividad - actividad_artista - artista para sacar el coste de actividad
CREATE VIEW vw_coste_actividad AS 
SELECT 
    A.id_actividad,
    A.nombre AS nombre_actividad,
    A.tipo AS tipo_actividad,
    SUM(ACT.cache_artista) AS coste_actividad,
    COUNT(ART.id_artista) AS numero_artistas
FROM actividad AS A 
JOIN actividad_artista AS ACT 
    ON A.id_actividad = ACT.id_actividad 
JOIN artista AS ART 
    ON ACT.id_artista = ART.id_artista
GROUP BY A.id_actividad, A.nombre, A.tipo;

-- Esto nos permite actualizar el coste en la tabla actividad.
UPDATE actividad A
JOIN vw_coste_actividad W 
    ON A.id_actividad = W.id_actividad
SET A.coste = W.coste_actividad;

-- Número de eventos por tipo_actividad 
SELECT
    A.tipo AS tipo_actividad,
    COUNT(E.id_evento) AS num_eventos
FROM evento AS E 
JOIN actividad AS A 
    ON A.id_actividad = E.id_actividad
GROUP BY A.tipo;

-- Eventos clasificados de más caro a más barato (precio entrada)
SELECT 
    nombre,
    precio_entrada,
    DENSE_RANK() OVER (ORDER BY precio_entrada) AS rank_entrada
FROM evento AS E
ORDER BY DENSE_RANK() OVER (ORDER BY precio_entrada);

-- Número de eventos por año y coste total
SELECT
    YEAR(fecha),
    COUNT(id_evento) AS numero_eventos,
    SUM(A.coste) AS coste_eventos
FROM evento AS E 
JOIN actividad AS A 
    ON E.id_actividad = A.id_actividad
GROUP BY YEAR(fecha)
ORDER BY YEAR(fecha);

-- Artistas clasificados por suma de caché para ver quién ha cobrado más
SELECT
    ART.nombre AS nombre_artista,
    SUM(ACT.cache_artista) AS total_cache,
    DENSE_RANK() OVER (ORDER BY SUM(ACT.cache_artista) DESC) AS cache_ranking
FROM actividad_artista AS ACT
JOIN artista AS ART 
    ON ART.id_artista = ACT.id_artista
GROUP BY ART.nombre;

-- Eventos clasificados por media de valoración: si valoracion_media IS NULL significa que no ha habido asistentes
SELECT 
    DENSE_RANK() OVER (ORDER BY AVG(AE.valoracion) DESC) AS posicion,
    E.nombre AS nombre_evento,
    AVG(AE.valoracion) AS valoracion_media
FROM evento AS E 
LEFT JOIN asistencia_evento AS AE 
    ON E.id_evento = AE.id_evento
GROUP BY E.nombre;

-- Listado de actividades realizadas con primera y última fecha
SELECT 
    ACT.id_actividad,
    ACT.nombre AS nombre_actividad,
    MIN(EV.fecha) AS primera_vez_actividad,
    MAX(EV.fecha) AS ultima_vez_actividad
FROM actividad AS ACT 
LEFT JOIN evento AS EV 
    ON ACT.id_actividad = EV.id_actividad
WHERE EV.fecha IS NOT NULL
GROUP BY ACT.id_actividad, ACT.nombre
ORDER BY ACT.id_actividad;

-- Teléfonos y email de los asistentes a determinados eventos
SELECT 
    AS_EV.id_evento,
    ATT.nombre_completo,
    TEL_AS.numero_telefono,
    ATT.email
FROM asistencia_evento AS AS_EV
JOIN telefono_asistente AS TEL_AS 
    ON AS_EV.id_asistente = TEL_AS.id_asistente
JOIN asistente AS ATT 
    ON ATT.id_asistente = TEL_AS.id_asistente
WHERE id_evento IN (4, 7);

-- Actividades donde ha participado más de 1 artista
SELECT 
    id_actividad,
    nombre_actividad,
    coste_actividad,
    numero_artistas
FROM vw_coste_actividad 
WHERE numero_artistas > 1;

-- Borrado de actividades no realizadas nunca
SET SQL_SAFE_UPDATES = 0;

DELETE A
FROM actividad AS A
LEFT JOIN evento AS E 
    ON A.id_actividad = E.id_actividad
WHERE E.id_evento IS NULL;

SET SQL_SAFE_UPDATES = 1;

