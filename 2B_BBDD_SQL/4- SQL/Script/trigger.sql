use tiendaInformatica;
/*
CREATE TRIGGER nombreDisp momentoDisp eventoDisp   
ON nombreTabla  
FOR EACH ROW  sentenciaDisp 

momentoDisp , cuando entra en acción. Puede ser BEFORE (antes) o AFTER 

eventoDisp con qué sentencia se activa. Puede ser INSERT, UPDATE, o DELETE. 

*/
# Verificar si hay unidades disponibles del artículo que queremos comprar
DELIMITER //
CREATE TRIGGER VerificarInventarioBI
BEFORE INSERT ON compra
FOR EACH ROW
BEGIN   
  DECLARE disponible INT;    
  SELECT unidades INTO disponible    
  FROM articulo    
  WHERE idArticulo = NEW.IDArticulo;   
  IF NEW.numUnidades > disponible 
    THEN  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficientes unidades disponibles para la venta';  
  END IF;
END;//
DELIMITER ;
# INSERT INTO `tiendainformatica`.`compra` (`idCliente`, `idArticulo`, `fecCompra`, `numUnidades`) 
         # VALUES ('019', '0002', '2025-03-03', '8');

#Actualizar el número de artículos una vez comprados
DELIMITER $$
# drop trigger if exists actualizarProductoAI ;
CREATE TRIGGER actualizarProductoAI
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
  update articulo 
  set unidades=unidades-NEW.numUnidades 
  where articulo.idArticulo=new.idArticulo;
END$$

DELIMITER ;
