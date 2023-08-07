
--SELECT * FROM recibo;
--SELECT * FROM detalle_venta;
--SELECT * FROM detalle_alquiler;
--SELECT * FROM alquiler;
--SELECT * FROM transaccion;
--SELECT * FROM venta;
--SELECT * FROM detalle_pedido;
--SELECT * FROM producto_pedido;
--SELECT * FROM inferior;
--SELECT * FROM superior;
--SELECT * FROM pedido;
--SELECT * FROM comprobante;
--SELECT * FROM empleado;
--SELECT * FROM cliente;
--SELECT * FROM documento;
--SELECT * FROM genero;
--SELECT * FROM producto;
--SELECT * FROM condicion;
--SELECT * FROM categoria;

--DECLARE @detalle_venta_v TABLE (id_producto_v varchar(15), cantidad_venta_v int)
--INSERT INTO @detalle_venta_v VALUES 
--	('PRO-1', 1),
--	('PRO-2', 2)

--SELECT cantidad_venta_v, p.stock_p
--FROM @detalle_venta_v dvv
--JOIN producto p ON dvv.id_producto_v = p.id_producto
	
-- ============================================================================================

--DECLARE @detalle_venta_v TABLE (id_producto_v varchar(15), cantidad_venta_v int)
--INSERT INTO @detalle_venta_v VALUES 
--    ('PRO-1', 1),
--    ('PRO-2', 2);

--SELECT 
--    dvv.id_producto_v,
--    dvv.cantidad_venta_v,
--    p.stock_p,
--    CASE WHEN dvv.cantidad_venta_v > p.stock_p THEN 'Exceso' ELSE 'OK' END AS estado
--FROM @detalle_venta_v dvv
--JOIN producto p ON dvv.id_producto_v = p.id_producto;

-- ============================================================================================

DECLARE @detalle_venta_v TABLE (id_producto_v varchar(15), cantidad_venta_v int)
INSERT INTO @detalle_venta_v VALUES 
    ('PRO-3', 1),
    ('PRO-2', 2),
	('PRO-1', 2)

DECLARE @can_proceed bit;

-- Comprobar si todas las cantidades son mayores o iguales a la cantidad disponible
SET @can_proceed = (
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM @detalle_venta_v dv
            JOIN producto p ON dv.id_producto_v = p.id_producto
            WHERE dv.cantidad_venta_v > p.stock_p
        ) THEN 1
        ELSE 0
    END
);
-- Si todas las cantidades son mayores o iguales, iniciar la secuencia de venta
IF @can_proceed = 1
BEGIN



    PRINT 'Se puede proceder con la venta.';



END
-- Si todas las cantidades NO son mayores o iguales, forzamos el error
ELSE
BEGIN
	RAISERROR('No se pueden vender productos con cantidades insuficientes.', 16, 1);
END