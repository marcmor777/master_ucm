DELIMITER $$

create function total_gastado_cliente(p_idCliente VARCHAR(3)) 
returns decimal(10,2)
deterministic
begin
    declare total decimal(10,2);

    select COALESCE(SUM(c.numUnidades * (a.precio - (a.precio * (a.descuento / 100)))), 0) 
              into total -- aquí estamos teniendo en cuenta los posibles descuentos
   from compra c inner join articulo a ON c.idArticulo = a.idArticulo
   where c.idCliente = p_idCliente;
 -- en este caso no necesito agrupar, porque sólo tengo un cliente el que he pasado como parámetro
    return total;
end $$
DELIMITER ;

SELECT total_gastado_cliente('011') AS totalGasto;

# Permite modificar el precio de un artículo y actualizar su precio final
DELIMITER $$

create procedure aplicar_descuento( in p_idArticulo VARCHAR(4), in p_descuento DECIMAL(5,2))-- dos parámetros sólo de entrada
begin
    -- Verificar que el artículo exista
if not exists (SELECT 1 FROM articulo WHERE idArticulo = p_idArticulo) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El artículo no existe.';
  elseif p_descuento < 0 OR p_descuento > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El descuento debe estar entre 0 y 100.';
   else
        -- Actualizar el descuento y el precio final
        update articulo 
        set descuento = p_descuento, 
            precioFinal = precio - (precio * (p_descuento / 100))
        where idArticulo = p_idArticulo;
    end if;
END $$

DELIMITER ;
CALL aplicar_descuento('0001', 20);

# Eliminar compras anteriores a una fecha

DELIMITER $$
drop procedure eliminar_compras_antiguas;
create procedure eliminar_compras_antiguas(in fechaDada date)-- parámetro de entrada a partir del que queremos borrar las compras
begin
    declare numEliminadas int;
    -- Contar cuántas compras se van a eliminar, si no hay compras no se ejecuta eliminar
    select COUNT(*) into numEliminadas
    FROM compra 
    WHERE fecCompra < fechaDada;
    select numEliminadas numeroEliminadas;
    -- Si no hay compras antiguas, mostrar mensaje
    if numEliminadas = 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay compras antiguas para eliminar.';
    else
        -- Eliminar las compras
       delete from compra 
        where fecCompra < fechaDada;
   end if;
END $$

DELIMITER ;
set sql_safe_updates=0;
call eliminar_compras_antiguas('2025-03-01');